# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time_in_float/version'

Gem::Specification.new do |spec|
  spec.name          = "time_in_float"
  spec.version       = TimeInFloat::VERSION
  spec.authors       = ["Kristaps Kulikovskis"]
  spec.email         = ["kristaps.kulikovskis@makit.lv"]

  spec.summary       = %q{Gem to handle floats that represent time e.g. 1.5 hours = 1 hour 50 minutes }
  spec.description   = %q{TODO: Write a detailed description}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
