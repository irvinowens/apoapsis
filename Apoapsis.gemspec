# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'Apoapsis/version'

Gem::Specification.new do |spec|
  spec.name          = "apoapsis"
  spec.version       = Apoapsis::VERSION
  spec.authors       = ["Irvin Owens Jr"]
  spec.email         = ["0xbadbeef@sigsegv.us"]
  spec.summary       = %q{A ruby framework for actor based supervisor development }
  spec.description   = %q{Use the actor/supervisor pattern made popular in Erlang/OTP in Ruby! }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "eventmachine"
end
