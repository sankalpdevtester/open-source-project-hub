# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :path or :git
Bundler.require(*Rails.groups)

module OpenSourceProjectHub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, defaults to: :sql
    config.active_record.database_selector = { delay: 5.seconds }
    config.active_record.legacy_connection_handling = false

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML entities in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use the new rendering pipeline for Rails 6 (optional for Rails 4.2)
    config.paths.add 'app/views', :prefix => 'open_source_project_hub'

    # Set Time zone
    config.time_zone = 'UTC'

    # Set default locale
    config.i18n.default_locale = :en

    # Set default host
    config.action_mailer.default_url_options = { host: 'localhost:3000' }

    # Set up database connection
    config.database_configuration = {
      development: {
        adapter: 'postgresql',
        encoding: 'unicode',
        host: 'localhost',
        database: 'open_source_project_hub_development',
        pool: 5,
        username: 'postgres',
        password: 'password'
      },
      test: {
        adapter: 'postgresql',
        encoding: 'unicode',
        host: 'localhost',
        database: 'open_source_project_hub_test',
        pool: 5,
        username: 'postgres',
        password: 'password'
      },
      production: {
        adapter: 'postgresql',
        encoding: 'unicode',
        host: 'localhost',
        database: 'open_source_project_hub_production',
        pool: 5,
        username: 'postgres',
        password: 'password'
      }
    }

    # Set up asset pipeline
    config.assets.paths << Rails.root.join('app', 'assets', 'images')
    config.assets.paths << Rails.root.join('app', 'assets', 'stylesheets')
    config.assets.paths << Rails.root.join('app', 'assets', 'javascripts')

    # Set up middleware
    config.middleware.use Rack::MethodOverride
    config.middleware.use Rack::Runtime
    config.middleware.use Rack::Lock

    # Set up session store
    config.session_store :cookie_store, key: '_open_source_project_hub_session'

    # Set up cache store
    config.cache_store = :memory_store

    # Set up logger
    config.logger = ActiveSupport::Logger.new(Rails.root.join('log', 'development.log'))

    # Set up mailer
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address: 'localhost',
      port: 25,
      domain: 'localhost:3000',
      user_name: nil,
      password: nil,
      authentication: nil,
      enable_starttls_auto: true
    }
  end
end