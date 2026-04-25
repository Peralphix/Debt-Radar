# frozen_string_literal: true

Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.dsn = ENV['SENTRY_DSN']
  config.traces_sample_rate = 1.0
  config.environment = Rails.env
  config.enabled_environments = %w[production staging]

  # Исключаем чувствительные параметры из логов
  config.send_default_pii = false
  config.excluded_exceptions += ['ActionController::RoutingError', 'ActiveRecord::RecordNotFound']

  # Добавляем контекст к каждому событию
  config.before_send = lambda do |event, hint|
    event.tags[:rails_env] = Rails.env
    event
  end
end
