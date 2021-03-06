require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ValuconTestTask
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    Dir["#{Rails.root}/lib/**/*.rb"].each { |file| require file }

    config.time_zone = 'Vladivostok'

    config.auth = {
      password_lengths: 8..32
    }
  end
end
