# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dvr/version'

Gem::Specification.new do |spec|
  spec.name          = "DVR"
  spec.version       = DVR::VERSION
  spec.authors       = ["Ryan Parker"]
  spec.email         = ["rypark09@gmail.com"]
  spec.description   = %q{A tool for testing hypermedia API's'}
  spec.summary       = %q{It tests hypermedia API's'}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",  "~> 1.3"
  spec.add_development_dependency "rake",     "~> 10.1"
  spec.add_development_dependency "minitest", "~> 5.0.6"
  spec.add_development_dependency "sinatra",  "~> 1.4.3"

end
