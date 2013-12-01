source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '>=4.0.1'
gem 'rake'

gem 'sass-rails'
gem 'cancan'
gem 'haml'
gem 'carrierwave'


gem 'mysql2'
gem 'pg'
# Allows the use of foreign keys used to protect data integrity (per Xavier Shay)
gem 'foreigner'
gem 'i18n'
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


gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Rails 4 support, see https://github.com/gregbell/active_admin/pull/2326
gem 'activeadmin',         github: 'gregbell/active_admin'#, branch: 'rails4'
