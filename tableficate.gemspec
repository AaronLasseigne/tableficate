# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'tableficate/version'

Gem::Specification.new do |spec|
  spec.name        = 'tableficate'
  spec.version     = Tableficate::VERSION
  spec.license     = 'MIT'
  spec.summary     = 'A DSL for Rails that provides easy table creation with sorting and filtering.'
  spec.description = spec.summary
  spec.homepage    = 'https://github.com/AaronLasseigne/tableficate'

  spec.authors     = ['Aaron Lasseigne']
  spec.email       = ['aaron.lasseigne@gmail.com']

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'actionpack', '>= 3.1'

  spec.add_development_dependency 'rake', '~> 10.1'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.2'
end
