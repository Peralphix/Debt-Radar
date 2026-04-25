# frozen_string_literal: true

class KadArbitr::Search < BaseSearch
  def initialize(inn)
    @inn = inn.to_s
  end

  def call
    KadArbitr::Request.new(inn: @inn).call
  rescue => e
    Rails.logger.error("Не удалось получить данные из сервиса Kad arbitr.")
    # тут какую-нибудь ошибку в сентри отсылать
    # raise RequestError, "Не удалось получить данные из сервиса Kad arbitr."
  end
end
