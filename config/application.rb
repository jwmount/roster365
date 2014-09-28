require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Roster365
class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Required by Heroku, http://guides.rubyonrails.org/asset_pipeline.html#manifest-files-and-directives
    config.assets.initialize_on_precompile = false

    # Suggest in http://stackoverflow.com/questions/19600905/undefined-method-flash-for-actiondispatchrequest?lq=1
    # apparently gem rails-api removes middleware Action::Flash needs, or something.
    # Set it to false to avoid this.  Apparently it defaults to true!
    config.api_only = false

    # CORS enable, see https://github.com/cyu/rack-cors
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

  end
end
