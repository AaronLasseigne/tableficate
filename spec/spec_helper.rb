ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../test_app/config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'

Rspec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_including :focus
  config.filter_run_excluding :ignore
end
