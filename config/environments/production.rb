# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.force_ssl = false
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info').to_sym
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
end
