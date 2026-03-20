require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module OpenSourceProjectHub
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = false
  end
end
