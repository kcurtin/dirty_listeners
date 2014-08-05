# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dirty_listeners/version'

Gem::Specification.new do |spec|
  spec.name          = "dirty_listeners"
  spec.version       = DirtyListeners::VERSION
  spec.authors       = ["Kevin Curtin"]
  spec.email         = ["kevincurtin88@gmail.com"]
  spec.summary       = %q{Add lifecycle aware dirty attribute listeners to your project.}
  spec.description   = %q{Hook into lifecycle events and attribute changes.}
  spec.homepage      = "http://kjcurtin.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activerecord'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
