source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '>=4.0.0'
gem 'rake'

gem 'sass-rails'
gem 'cancan'
gem 'haml'
gem 'carrierwave'

# Rails 4 support, see https://github.com/gregbell/active_admin/pull/2326
gem 'activeadmin',         github: 'gregbell/active_admin', branch: 'rails4'

gem 'mysql2'
gem 'pg'
gem 'taps'  #needed by Heroku

# Needed for Rails 4.0 on Heroku
gem 'rails_12factor', group: :production

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :production do
  # gem 'mysql2'  On AWS using RDS instead
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
  gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
gem 'debugger'
