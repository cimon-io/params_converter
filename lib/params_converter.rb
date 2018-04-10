# frozen_string_literal: true

require 'params_converter/version'

module ParamsConverter # :nodoc:
  class ParamsConverterError < ::StandardError # :nodoc:
    def initialize(msg = nil)
      msg = msg.is_a?(Array) ? msg.join(',') : msg.to_s
      super("#{message_prefix} #{msg}")
    end
  end

  class NotAllowedError < ParamsConverterError # :nodoc:
    def message_prefix
      'Not allowed keys'
    end
  end

  class MissingRequiredError < ParamsConverterError # :nodoc:
    def message_prefix
      'Missing keys'
    end
  end

  class Adjustor # :nodoc:
    attr_reader :params,
                :required_keys,
                :allowed_keys

    def initialize(params, required_keys, allowed_keys)
      @params = check_and_symbolize_keys!(params, Hash)
      @required_keys = check_and_symbolize!(required_keys, nil, Array)
      @allowed_keys = check_and_symbolize!(allowed_keys, nil, Array)
    end

    def perform
      required_keys_filter unless required_keys.nil?
      allowed_keys_filter unless allowed_keys.nil?
      params
    end

    private

    def required_keys_filter
      raise_if_any(MissingRequiredError, missing_keys)
    end

    def allowed_keys_filter
      raise_if_any(NotAllowedError, not_allowed_keys)
    end

    def missing_keys
      @missing_keys ||= required_keys - param_keys
    end

    def not_allowed_keys
      @not_allowed_keys ||= param_keys - [*allowed_keys, *required_keys]
    end

    def param_keys
      @param_keys ||= params.keys
    end

    def raise_if_any(error, keys)
      raise(error, keys) if keys.any?
    end

    def check_and_symbolize_keys!(value, *allowed_values)
      value = prepare(value)
      check_params!(value, allowed_values)
      hash_with_symbolized_keys(value)
    end

    def prepare(value)
      value = value.to_unsafe_h if value.respond_to?(:to_unsafe_h)
      value = value.to_h if value.respond_to?(:to_h)
      value
    end

    def check_params!(value, allowed_values)
      case value
      when *allowed_values
        value
      else
        raise ArgumentError
      end
    end

    def check_and_symbolize!(value, *allowed_values)
      check_params!(value, allowed_values)
      return if value.nil?
      symbolized_uniq_array(value)
    end

    def symbolized_uniq_array(value)
      value.map { |v| symbolize(v) }.uniq
    end

    def symbolize(value)
      value.to_s.to_sym
    end

    def hash_with_symbolized_keys(value)
      Hash[value.map { |k, v| [symbolize(k), v] }]
    end
  end

  def convert!(params, required_keys = nil, allowed_keys = nil)
    Adjustor.new(params, required_keys, allowed_keys).perform
  end
  module_function :convert!
end
