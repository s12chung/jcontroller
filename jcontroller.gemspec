# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jcontroller/version'

Gem::Specification.new do |spec|
  spec.name          = "jcontroller"
  spec.version       = Jcontroller::VERSION
  spec.authors       = ["Steve Chung"]
  spec.email         = ["steve.chung7@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 3.2'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "capybara-webkit"
  spec.add_development_dependency "rspec-rails", "~> 2.14.0"
  spec.add_development_dependency "jbuilder"
  spec.add_development_dependency "jquery-rails"
  spec.add_development_dependency "rake"
end
