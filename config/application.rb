require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExpatUnlocked
  class Application < Rails::Application
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.generators do |generate|
          generate.assets false
          generate.helper false
          generate.test_framework  :test_unit, fixture: false
        end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.action_view.embed_authenticity_token_in_remote_forms = true


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { :api_token => "fa7bfc7b-1226-4bd3-ad76-d25350bd4319" }
  end
end
