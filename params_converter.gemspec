# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'params_converter/version'

Gem::Specification.new do |spec|
  spec.name          = "params_converter"
  spec.version       = ParamsConverter::VERSION
  spec.authors       = ["Alexey Osipenko"]
  spec.email         = ["alexey@osipenko.in.ua"]

  spec.summary       = %q{Rich version of assert_valid_keys method}
  spec.description   = %q{Rich version of assert_valid_keys method}
  spec.homepage      = "https://github.com/cimon-io/params_converter"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec"
end
