require "params_converter/version"

module ParamsConverter

  class ParamsConverterError < ::StandardError
    def initialize(msg = nil)
      msg = msg.is_a?(Array) ? msg.join(',') : msg.to_s
      super("#{message_prefix} #{msg}")
    end
  end

  class NotAllowedError < ParamsConverterError
    def message_prefix
      "Not allowed keys"
    end
  end

  class MissingRequiredError < ParamsConverterError
    def message_prefix
      "Missing keys"
    end
  end

  def convert!(params, re=nil, pe=nil)
    raise ArgumentError unless re.nil? or re.is_a?(Array)
    raise ArgumentError unless pe.nil? or pe.is_a?(Array)
    raise ArgumentError unless params.is_a?(Hash)

    params = Hash[params.map { |k,v| [k.to_s.to_sym, v] }]

    unless re.nil?
      re = re.map(&:to_s).map(&:to_sym).uniq
      missing_keys = re.reject { |r| !!params.fetch(r, false) }
      raise MissingRequiredError.new(missing_keys) if missing_keys.count > 0
    end

    pe = params.keys if pe.nil?
    pe = ((re || []) | pe).map(&:to_s).map(&:to_sym).uniq
    not_allowed_keys = params.keys - pe
    raise NotAllowedError.new(not_allowed_keys) if not_allowed_keys.count > 0

    params
  end
  module_function :convert!

end
