source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '>=4.1'
gem 'rake', '10.1.0'

gem 'coffee-rails'
gem 'sass-rails'
gem "twitter-bootstrap-rails"
gem "bootstrap-sass"
gem 'haml-rails'
gem 'geocoder'
gem 'carrierwave'
gem 'devise'
gem 'cancan'
gem 'pg'

gem 'i18n'
gem 'taps'  #needed by Heroku

gem 'uglifier', '>= 1.0.3'

group :development do
  gem 'better_errors'	
  gem 'binding_of_caller'
  gem 'debugger'
end

group :production do
  # gem 'mysql2'  On AWS using RDS instead
  # Support for Rails 4 by & for Heroku
  gem 'rails_12factor'
  # needed for asset pipeline cache by Heroku, all 4.0.x releases, is in 4.1.x
  gem 'sprockets_better_errors'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'


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
# http://stackoverflow.com/questions/20648814/rails-4-1-0-beta1-upgrade-fails
gem 'formtastic', github: 'justinfrench/formtastic'
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'
gem 'polyamorous', github: 'activerecord-hackery/polyamorous'
gem 'activeadmin', github: 'gregbell/active_admin'