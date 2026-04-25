# frozen_string_literal: true

class PbNalog::Search < BaseSearch
  def initialize(inn)
    @inn = inn.to_s
  end

  def call
    search_id = PbNalog::Request::SearchId.new(@inn).call
    search_id_not_found! unless search_id

    result = PbNalog::Request::Result.new(search_id).call
    result_data = get_data(result)

    return { raw_data: result } if result_data.blank?
    parsed_data = PbNalog::ResponseParser.new(result_data).call
    { parsed_data:, raw_data: result_data }
  rescue RequestError => e
    Sentry.capture_exception(e, extra: { service: 'PbNalog', inn: @inn })
    raise e
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { service: 'PbNalog', inn: @inn })
    raise RequestError, "Не удалось получить данные из сервиса PB Nalog"
  end

  def search_id_not_found!
    raise RequestError, "Не удалось получить данные из сервиса PB nallog: search ID не получен"
  end

  def get_data(result)
    result.dig("ul", "data")&.first || result.dig("ip", "data")&.first
  end
end
