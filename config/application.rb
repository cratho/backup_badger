require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
# require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BackupBadger
  # Application Settings
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

    # Allowed options: :sql, :ruby.
    config.sequel.schema_format = :ruby

    # Whether to dump the schema after successful migrations.
    # Defaults to false in production and test, true otherwise.
    config.sequel.schema_dump = true

    # These override corresponding settings from the database config.
    config.sequel.max_connections = 16
    config.sequel.search_path = %w(mine public)

    # Configure whether database's rake tasks will be loaded or not.
    #
    # If passed a String or Symbol, this will replace the `db:` namespace for
    # the database's Rake tasks.
    #
    # ex: config.sequel.load_database_tasks = :sequel
    #     will results in `rake db:migrate` to become `rake sequel:migrate`
    #
    # Defaults to true
    config.sequel.load_database_tasks = true

    # This setting disabled the automatic connect after Rails init
    config.sequel.skip_connect = false

    # If you want to use a specific logger
    # config.sequel.logger = MyLogger.new($stdout)

    config.generators do |g|
      g.test_framework :rspec
    end

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]
  end
end
