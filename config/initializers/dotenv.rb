# frozen_string_literal: true

# Загрузка переменных окружения из .env файла
if defined?(Dotenv)
  Dotenv::Railtie.load
end
