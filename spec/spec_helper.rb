ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../test_app/config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
