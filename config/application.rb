require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShinchokuNote
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Set locale to Japanese
    config.i18n.default_locale = :ja

    # Setting for sqlite3 in test env
    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = false
  end
end
