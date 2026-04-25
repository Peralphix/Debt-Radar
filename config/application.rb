# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require "active_record/railtie"
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'

Bundler.require(*Rails.groups)

module ArbitrBot
  class Application < Rails::Application
    config.load_defaults 7.1

    # Автозагрузка путей
    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')

    # Часовой пояс
    config.time_zone = 'Moscow'

    # Логирование
    config.log_level = :info

    # Sidekiq для фоновых задач
    config.active_job.queue_adapter = :sidekiq

    # API-only режим
    config.api_only = true
  end
end
