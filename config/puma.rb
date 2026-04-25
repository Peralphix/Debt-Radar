# frozen_string_literal: true

# Количество воркеров (процессов)
workers ENV.fetch('WEB_CONCURRENCY', 2)

# Минимальное и максимальное количество потоков
threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
threads threads_count, threads_count

# Порт
port ENV.fetch('PORT', 3000)

# Окружение
environment ENV.fetch('RAILS_ENV', 'development')

# Preload приложения
preload_app!

# Пути для PID и состояния
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')
state_path ENV.fetch('STATEFILE', 'tmp/pids/puma.state')

# Подключение к базе после форка (если будет использоваться ActiveRecord)
on_worker_boot do
  # ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
