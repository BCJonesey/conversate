source 'https://rubygems.org'

ruby "2.0.0"
gem 'rails', '>= 4.0.2'
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
gem 'unicorn' # A magick web server. The horns are used for dark incantations.
gem 'backbone-rails'	# Used for including the backbone.js files and general integration.
gem 'ejs'	# Required for the .ejs templates.
gem 'newrelic_rpm' # For New Relic analytics.
gem 'quiet_assets'

gem 'mandrill-api'
gem 'email_reply_parser'

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "yaml_db"
  gem 'thin'  # A minimalist web server. Heroku likes it.
end

gem "ruby-prof"

gem "protected_attributes" # Let's us use the old-style attr_accessible calls.
gem "rails_serve_static_assets" # Let's us actually serve our assets with heroku on rails 4.

# File upload plugin that is pretty. https://github.com/semaperepelitsa/jquery.fileupload-rails
gem 'jquery.fileupload-rails'

# For making S3 calls. We might eventually have to move the logic out to the client, but let's do the simplest
# thing first.
gem 'aws-sdk'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
