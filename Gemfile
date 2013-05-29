source 'http://rubygems.org'

gem 'rails', '3.2.12'
gem 'thin'
gem 'rake'

gem 'devise'
gem 'meta_search'
gem "database_cleaner"
gem "audited-activerecord", "~> 3.0"
gem "inherited_resources"
# per Greg Bell
gem "activeadmin", :git => "git://github.com/gregbell/active_admin.git"

gem "cancan"
gem "nested_has_many_through"
gem "spreadsheet"
gem "carrierwave"
gem "simple_enum", :git => "https://github.com/lwe/simple_enum.git"
gem "haml-rails"
gem "formtastic", ">=2.1.1"
gem 'sass-rails',   '~> 3.2.3'
gem 'jquery-rails'
gem 'dynamic_form'
gem 'json', '1.7.7'
gem 'best_in_place'

# Deploy with Capistrano
# gem 'capistrano'

 gem 'pg' # turn on for HEROKU

group :development do
  gem 'debugger'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'mysql2' # AWS EB
end