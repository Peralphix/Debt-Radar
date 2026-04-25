# Arbitr Telegram Bot

Telegram бот для поиска арбитражных дел по ИНН на сайте [kad.arbitr.ru](https://kad.arbitr.ru).

## Возможности

- 🔍 Поиск арбитражных дел по ИНН организации или ИП
- 📋 Отображение информации о делах: номер, суд, дата, стороны
- 🔗 Прямые ссылки на карточки дел
- ⚡ Два режима работы: polling и webhook

## Требования

- Ruby 3.2.0+
- Bundler
- Redis (для Sidekiq, опционально)
- Chrome/Chromium (для Selenium fallback, опционально)

## Установка

### 1. Клонирование и установка зависимостей

```bash
cd arbitr_bot
bundle install
```

### 2. Настройка переменных окружения

Скопируйте файл с примером настроек:

```bash
cp env.sample .env
```

Отредактируйте `.env` файл:

```env
TELEGRAM_BOT_TOKEN=ваш_токен_бота
REDIS_URL=redis://localhost:6379/0
RAILS_ENV=development
```

### 3. Получение токена Telegram бота

1. Откройте [@BotFather](https://t.me/BotFather) в Telegram
2. Отправьте команду `/newbot`
3. Следуйте инструкциям для создания бота
4. Скопируйте полученный токен в `.env` файл

## Запуск

### Режим Polling (рекомендуется для разработки)

```bash
# Через rake task
bundle exec rake bot:start

# Или напрямую
bundle exec ruby bin/bot
```

### Режим Webhook (для production)

1. Запустите Rails сервер:

```bash
bundle exec rails server -p 3000
```

2. Настройте webhook в Telegram:

```bash
curl -X POST "https://api.telegram.org/bot<TOKEN>/setWebhook" \
  -d "url=https://your-domain.com/telegram/webhook"
```

3. Запустите Sidekiq для фоновой обработки:

```bash
bundle exec sidekiq -C config/sidekiq.yml
```

### Через Procfile (Foreman/Overmind)

```bash
# Установите foreman
gem install foreman

# Запустите все процессы
foreman start

# Или только бота
foreman start bot
```

## Использование

### Команды бота

| Команда | Описание |
|---------|----------|
| `/start` | Приветствие и справка |
| `/help` | Подробная справка |
| `/search <ИНН>` | Поиск по ИНН |

### Примеры

- Отправьте `7707083893` — поиск по ИНН Сбербанка
- Отправьте `/search 7736207543` — поиск по ИНН Яндекса

## Структура проекта

```
arbitr_bot/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   └── telegram_controller.rb    # Webhook endpoint
│   └── jobs/
│       └── telegram_webhook_job.rb   # Фоновая обработка
├── bin/
│   └── bot                           # Скрипт запуска
├── config/
│   ├── application.rb
│   ├── environment.rb
│   ├── environments/
│   ├── routes.rb
│   ├── puma.rb
│   └── sidekiq.yml
├── lib/
│   ├── arbitr_parser.rb              # Парсер kad.arbitr.ru
│   ├── telegram_bot.rb               # Polling режим
│   └── telegram_bot_handler.rb       # Webhook режим
├── Gemfile
├── Procfile
├── Rakefile
├── config.ru
└── env.sample
```

## Как работает парсинг

1. **HTTP API** — бот отправляет POST-запрос к API kad.arbitr.ru с ИНН в параметрах
2. **Парсинг JSON** — ответ API содержит список дел в JSON формате
3. **Selenium Fallback** — если API недоступен, используется headless Chrome

### Ограничения

- Сайт kad.arbitr.ru может блокировать частые запросы
- Selenium fallback требует установленного Chrome
- Показываются первые 10 дел из результатов

## Деплой

### Docker

```dockerfile
FROM ruby:3.2.0-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    chromium \
    chromium-driver

WORKDIR /app
COPY Gemfile* ./
RUN bundle install
COPY . .

CMD ["bundle", "exec", "ruby", "bin/bot"]
```

### Heroku

```bash
heroku create
heroku config:set TELEGRAM_BOT_TOKEN=ваш_токен
git push heroku main
heroku ps:scale bot=1
```

## Troubleshooting

### Ошибка "TELEGRAM_BOT_TOKEN не задан"

Убедитесь, что файл `.env` существует и содержит корректный токен.

### Ошибка парсинга kad.arbitr.ru

- Проверьте интернет-соединение
- Сайт может быть временно недоступен
- Возможно, API изменился — проверьте актуальность парсера

### Chrome не найден (для Selenium)

```bash
# macOS
brew install --cask chromium

# Ubuntu/Debian
apt-get install chromium-browser chromium-chromedriver
```

## Лицензия

MIT
