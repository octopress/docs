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

  spec.files         = `git ls-files -z`.split("\x0").grep(/^(bin\/|lib\/|assets\/|changelog|readme|license)/i)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "jekyll", "~> 2.0"
  spec.add_runtime_dependency "octopress", "~> 3.0.0.rc"
  spec.add_runtime_dependency "octopress-ink", "~> 1.0.0.rc"
  spec.add_runtime_dependency "octopress-solarized", "~> 1.0"
  spec.add_runtime_dependency "octopress-escape-code", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  if RUBY_VERSION >= "2"
    spec.add_development_dependency "pry-debugger"
  end
end
