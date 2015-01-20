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

gem 'react-rails', '~> 0.12.2.0'	# Used for including the react.js files.
gem 'coffee-rails' # For that sweet, sweet extra syntax
gem 'lodash-rails'
# It's ours!  We wrote it!
gem 'hippodrome'

gem 'newrelic_rpm' # For New Relic analytics.
gem 'quiet_assets'
gem 'rack-rewrite' # Allows us to do middleware 301 redirects, like from www to bare sld.

gem 'mandrill-api'
gem 'email_reply_parser'
gem 'reverse_markdown'

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem "yaml_db"
  gem 'thin'  # A minimalist web server. Heroku likes it.
  gem 'jasmine-core', '~> 2.1.2'
  gem 'jasmine-rails'
end

gem "ruby-prof"

gem "protected_attributes" # Lets us use the old-style attr_accessible calls.
gem "rails_serve_static_assets" # Lets us actually serve our assets with heroku on rails 4.

group :production do
  gem "rails_stdout_logging" # Lets Heroku actually read our logs. Production only, or you will see much output.
end


# File upload plugin that is pretty. https://github.com/semaperepelitsa/jquery.fileupload-rails
gem 'jquery.fileupload-rails'

# For making S3 calls. We might eventually have to move the logic out to the client, but let's do the simplest
# thing first.
gem 'aws-sdk'

# Also for dealing with files.
gem 'paperclip'

# For cacheing sanely.
gem 'memcachier'
gem 'dalli'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
