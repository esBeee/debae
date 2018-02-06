ruby '2.4.1' # Specify ruby version for heroku
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1', '>= 5.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21.0'
# Use Puma as the app server
gem 'puma', '~> 3.10'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2'
# Specify nokogiri to make sure a version bigger than 1.8.1 is being used. Lower
# versions suffer from known critical severity security vulnerabilities.
gem 'nokogiri', '~> 1.8', '>= 1.8.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.0', '>= 5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use HAML to write HTML
gem 'haml-rails', '~> 1.0'
# Use font awesome icons
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.2'

# Use devise for user authentication
gem 'devise', '~> 4.3'
# Provide OAuth with facebook
gem 'omniauth-facebook', '~> 4.0'
# Provide OAuth with twitter
gem 'omniauth-twitter', '~> 1.4'
# Provide OAuth with google
gem 'omniauth-google-oauth2', '~> 0.5.2'
# Use the will_paginate gem for pagination. Provides the #page method
# used in controllers for pagination
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
# Use Kazus for a convenient logging method
gem 'kazus', git: 'git://github.com/esBeee/kazus.git' #, path: "../_gems/kazus"
# Add some basic translations
gem 'rails-i18n', '~> 5.0', '>= 5.0.4'
# The paperclip gem manages user avatars
gem 'paperclip', '~> 5.2', '>= 5.2.1'
# Helper to store user avatars on S3
gem 'aws-sdk', '~> 2.5', '>= 2.5.3'
# Using the sitemap generator gem to generate a new sitemap
# according to the config in config/sitemap.rb
gem 'sitemap_generator', '~> 5.1'
# This gem is required by the sitemap generator to upload the generated
# sitemap to S3.
gem 'fog-aws', '~> 0.9.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Use RSpec for testing
  gem 'rspec-rails', '~> 3.6', '>= 3.6.1'

  # Use Factory Girl to build, create or stub test-objects
  gem 'factory_girl_rails', '~> 4.7'

  # Use brakeman to analyse the code for security vulnerabilities.
  #
  # Run
  #
  # $ brakeman
  #
  # in the root directory to start the analysis.
  gem 'brakeman', require: false
end

group :test do
  # Use the capybara integration testing tool to simulate user behaviour in RSpec tests
  gem 'capybara', '~> 2.7'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # Use this gem to automatically generate favicons for all sizes and devices
  gem 'rails_real_favicon', '~> 0.0.7'
end

group :production do
  # Heroku dependency
  gem 'rails_12factor', '~> 0.0.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
