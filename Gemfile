source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'

gem 'pg'

gem 'passenger', '>= 5.0.25', require: 'phusion_passenger/rack_handler'

gem 'aasm'
gem 'bcrypt', '~> 3.1.7'
gem 'carrierwave'
gem 'dotenv-rails'
gem 'factory_girl_rails', require: false  # used for rake task to generate random data
gem 'fast_blank'
gem 'ffaker', require: false
gem 'mini_magick'
gem 'pry-rails'
gem 'pundit'
gem 'show_data', require: false
gem 'simple_form'

# Front-end gems
gem 'bootstrap-sass', '~> 3.3.6'
gem 'jquery-rails'
gem 'sassc-rails'
gem 'slim-rails'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'annotate'
  gem 'better_errors'
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails'
  gem 'capistrano-rails-console'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', github: 'pschambacher/database_cleaner', branch: 'rails5.0'
  gem 'pundit-matchers', '~> 1.1.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
end
