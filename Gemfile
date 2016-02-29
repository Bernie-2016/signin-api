source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'rails-api'

gem 'blue_state_digital'
gem 'cancancan'
gem 'pg'
gem 'rack-cors', require: 'rack/cors'
gem 'rest-client'
gem 'rollbar'
gem 'sidekiq'

group :production do
  gem 'passenger'
  gem 'rails_12factor'
end

group :development do
  gem 'byebug'
end

group :development, :test do
  gem 'database_cleaner'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'shoulda-matchers'
  gem 'sqlite3'
  gem 'pry'
  gem 'pry-rails'
end

group :test do
  gem 'simplecov'
  gem 'webmock'
end
