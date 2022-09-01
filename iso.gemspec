# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iso/version'

Gem::Specification.new do |spec|
  spec.name          = "iso-swift"
  spec.version       = ISO::VERSION
  spec.authors       = ["Hugo Lantaume"]
  spec.email         = ["hugolantaume@gmail.com"]
  spec.summary       = %q{Swift code validation and lookup Ruby gem}
  spec.description   = %q{}
  spec.homepage      = "http://github.com/hugolantaume/iso-swift"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "countries", ">= 4.2"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
end
