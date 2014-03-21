# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-docs/version'

Gem::Specification.new do |spec|
  spec.name          = "octopress-docs"
  spec.version       = Octopress::Docs::VERSION
  spec.authors       = ["Brandon Mathis"]
  spec.email         = ["brandon@imathis.com"]
  spec.description   = %q{View docs for Octopress and its plugins}
  spec.summary       = %q{View docs for Octopress and its plugins}
  spec.homepage      = "https://github.com/octopress/docs"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "octopress-ink", "~> 1.0.0.rc.1"
  spec.add_runtime_dependency "octopress", "~> 3.0.0.rc.5"
  spec.add_runtime_dependency "jekyll", "~> 1.4.2"

  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
