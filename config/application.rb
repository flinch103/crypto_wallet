require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vodix
  # application configuration file
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.autoload_paths += Dir.glob("#{config.root}/app/interactions/*")
    config.to_prepare do
      Devise::SessionsController.layout 'devise'
      Devise::RegistrationsController.layout 'devise'
      Devise::ConfirmationsController.layout 'devise'
      Devise::PasswordsController.layout 'devise'
    end
    config.active_job.queue_adapter = :sidekiq
  end
end
