# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marketwatch/version'

Gem::Specification.new do |s|
  s.name          = 'marketwatch'
  s.version       = Marketwatch::VERSION
  s.authors       = ['fengb']
  s.email         = ['contact@fengb.info']
  s.summary       = %q{TODO: Write a short summary. Required.}
  s.description   = %q{TODO: Write a longer description. Optional.}
  s.homepage      = ''
  s.license       = 'MIT'

  s.files         = Dir["lib/**/*"] + %w{LICENSE Rakefile README.md}
  s.test_files    = s.files.grep(%r{^(test|s|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.1'
end
