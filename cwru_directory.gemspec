# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cwru_directory/version'

Gem::Specification.new do |spec|
  spec.name          = "cwru_directory"
  spec.version       = CWRUDirectory::VERSION
  spec.authors       = ["Andrew Mason"]
  spec.email         = ["mason@case.edu"]

  spec.summary       = "Gem for making queries with the Case Western Reserve University directory listing"
  spec.homepage      = "https://github.com/ajm188/cwru_directory"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'mechanize'
end
