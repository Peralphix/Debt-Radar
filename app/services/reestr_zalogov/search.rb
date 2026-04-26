# frozen_string_literal: true

class ReestrZalogov::Search < BaseSearch
  def initialize(vin)
    @vin = vin.to_s
  end

  def call
    ReestrZalogov::Request.new(vin: @vin).call
  rescue => e
    Rails.logger.error("Не удалось получить данные из сервиса Reestr Zalogov.")
    # отправлять ошибку в сентри
  end
end
