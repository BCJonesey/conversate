source 'https://rubygems.org'

gem 'rails', '>= 3.2.11'
gem 'pry-rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

group :development do
  gem 'sqlite3'
end

group :development, :test do
  gem 'jasmine'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'less-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'sorcery'	# For login and security.
gem 'thin'	# A minimalist web server. Heroku likes it.
gem 'backbone-rails'	# Used for including the backbone.js files and general integration.
gem 'ejs'	# Required for the .ejs templates.
gem 'newrelic_rpm' # For New Relic analytics.
gem 'quiet_assets'

gem 'mandrill-api'
gem 'email_reply_parser'

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "yaml_db"
end

# Pulling this out for now.
gem "ruby-prof"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
