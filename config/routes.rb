# frozen_string_literal: true

Rails.application.routes.draw do
  post '/public-api/check-user', to: 'public_api#check_user'

  # Health check
  get '/health', to: proc { [200, {}, ['OK']] }
end
