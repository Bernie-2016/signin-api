require 'codeclimate-test-reporter'
require 'simplecov'

SimpleCov.formatter = CodeClimate::TestReporter::Formatter if ENV['CIRCLE_ARTIFACTS']

SimpleCov.start do
  coverage_dir 'spec/coverage'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'

  add_filter 'app/workers'
  add_filter 'config'
  add_filter 'spec'
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
Rails.application.eager_load!

require 'rspec/rails'

require 'database_cleaner'
require 'webmock/rspec'

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Include appropriate helpers for controller specs.
  config.infer_spec_type_from_file_location!

  # Include FactoryGirl methods.
  config.include FactoryGirl::Syntax::Methods

  # Maintain clean database.
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
