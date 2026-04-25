# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Повторные попытки при ошибках
  # retry_on StandardError, wait: :polynomially_longer, attempts: 3
  sidekiq_options retry: false

  # Логирование
  around_perform do |job, block|
    Rails.logger.info("Started #{job.class.name} with args: #{job.arguments}")
    block.call
    Rails.logger.info("Completed #{job.class.name}")
  rescue StandardError => e
    Rails.logger.error("Failed #{job.class.name}: #{e.message}")
    Sentry.capture_exception(e, extra: { job: job.class.name, arguments: job.arguments })
    raise
  end
end
