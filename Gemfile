source 'https://rubygems.org'
ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'

gem 'rake'
gem 'activerecord'
gem 'foreman'

# sprockets Environment error, it's ALWAYS sprockets
# http://stackoverflow.com/questions/22426698/undefined-method-environment-for-nilnilclass-when-importing-bootstrap-into-ra
gem 'uglifier', '>= 1.0.3'
gem 'coffee-rails'

gem "twitter-bootstrap-rails"
gem "bootstrap-sass"
gem "therubyracer"
#gem "less-rails"   # added to move to frontend
gem "angular-rails"
gem "angular-rails-templates"  # added to move to frontend, http://angular-rails.com/find_and_browse.html
gem 'haml-rails'
gem 'geocoder'

gem 'carrierwave'
gem 'devise'

gem 'cancan'
# Allows the use of foreign keys used to protect data integrity (per Xavier Shay)
gem 'i18n'
gem 'taps'  #needed by Heroku
gem 'pg'
gem "country_select"



group :development do
  gem 'debugger2'
  gem 'better_errors' 
  gem 'binding_of_caller'
end

group :production do
  # Support for Rails 4 by & for Heroku
  # https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
    # gem 'rails_12factor'
  # needed for asset pipeline cache by Heroku, all 4.0.x releases, is in 4.1.x
  # gem 'sprockets_better_errors'  DOES NOT WORK AFTER RAILS 4.0.5, causes the notorious render fail
  gem 'puma', '~> 3.11'  
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON


gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

group :assets do
  gem 'jquery-ui-rails'
end

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Rails 4 support, see https://github.com/gregbell/active_admin/pull/2326
# http://stackoverflow.com/questions/20648814/rails-4-1-0-beta1-upgrade-fails
gem 'formtastic' #, github: 'justinfrench/formtastic'
gem 'ransack' #, github: 'activerecord-hackery/ransack', branch: 'rails-4.1'
#gem 'polyamorous', github: 'activerecord-hackery/polyamorous'
gem 'activeadmin', github: 'gregbell/active_admin'

# CORS using ransack
# https://github.com/cyu/rack-cors
gem 'rack-cors', :require => 'rack/cors'
gem "json", "~> 1.8"
