# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tableficate/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'tableficate'
  gem.version     = Tableficate::VERSION

  gem.authors     = ['Aaron Lasseigne']
  gem.email       = ['aaron.lasseigne@gmail.com']
  gem.summary     = %q{A DSL for Rails that provides easy table creation with sorting and filtering.}
  gem.description = %q{A DSL for Rails that provides easy table creation with sorting and filtering.}
  gem.homepage    = 'https://github.com/AaronLasseigne/tableficate'

  gem.rubyforge_project = 'tableficate'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency 'rails', '>= 3.1'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'genspec'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'capybara'
end
