# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'topsy_api/version'

Gem::Specification.new do |spec|
  spec.name          = "topsy_api"
  spec.version       = TopsyApi::VERSION
  spec.authors       = ["Amar Daxini"]
  spec.email         = ["amardaxini@gmail.com"]
  spec.description   = %q{"Topsy API Ruby Wrapper"}
  spec.summary       = %q{Topsy API Ruby Wrapper"}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "oj"
  spec.add_development_dependency "bundler", "~> 1.3"
  
  spec.add_development_dependency "rake"
end
