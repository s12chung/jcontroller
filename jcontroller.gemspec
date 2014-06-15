# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jcontroller/version'

Gem::Specification.new do |spec|
  spec.name          = "jcontroller"
  spec.version       = Jcontroller::VERSION
  spec.authors       = ["Steve Chung"]
  spec.email         = ["steve.chung7@gmail.com"]
  spec.summary       = %q{ Controller based javascript outside of your view files. }
  spec.description   = %q{ DOM-based Routing for Rails controller based javascript. }
  spec.homepage      = "https://github.com/s12chung/jcontroller"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4.0'
  spec.add_dependency 'request_store'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "poltergeist"
  spec.add_development_dependency "launchy"
  spec.add_development_dependency "jbuilder"
  spec.add_development_dependency "jquery-rails"
end
