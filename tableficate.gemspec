# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tableficate/version'

Gem::Specification.new do |gem|
  gem.name        = 'tableficate'
  gem.version     = Tableficate::VERSION
  gem.summary     = 'A DSL for Rails that provides easy table creation with sorting and filtering.'
  gem.description = gem.summary
  gem.homepage    = 'https://github.com/AaronLasseigne/tableficate'

  gem.authors     = ['Aaron Lasseigne']
  gem.email       = ['aaron.lasseigne@gmail.com']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rails',        '>= 3.1'
  gem.add_dependency 'with_order',   '~> 0.1.0'
  gem.add_dependency 'with_filters', '~> 0.1.2'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'genspec'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent'
end
