# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dont_comment/version'

Gem::Specification.new do |spec|
  spec.name          = "dont_comment"
  spec.version       = DontComment::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["kuwabara@pocke.me"]

  spec.summary       = %q{Do not comment out unused code, use version control system instead and remove it!}
  spec.description   = %q{Do not comment out unused code, use version control system instead and remove it!}
  spec.homepage      = "https://github.com/pocke/dont_comment"
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency 'parser'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", ">= 0.48.1"
  spec.add_development_dependency "meowcop"

  # testing
  spec.add_development_dependency "minitest", "~> 5.9.0"
  spec.add_development_dependency "minitest-power_assert", "~> 0.2.0"
  spec.add_development_dependency 'guard', '~> 2.13.0'
  spec.add_development_dependency 'guard-minitest', '~> 2.4.4'
  spec.add_development_dependency 'guard-bundler', '~> 2.1.0'
end
