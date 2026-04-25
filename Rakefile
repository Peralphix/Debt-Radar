# frozen_string_literal: true

require_relative 'config/application'

Rails.application.load_tasks

namespace :bot do
  desc 'Запуск Telegram бота в режиме polling'
  task start: :environment do
    TelegramBot.new.start
  end
end
