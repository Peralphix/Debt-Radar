# frozen_string_literal: true

class TrafficFines::Search < BaseSearch
  def initialize(sts_number)
    @sts_number = sts_number.to_s
  end

  def call
    cookies = fetch_cookies
    result = TrafficFines::Request::GetFines.new(@sts_number, cookies: cookies).call

    if result["code"] != "SUCCESS"
      error_message = "Не удалось получить данные из сервиса штрафов: #{result["message"]}"
      Rails.logger.error(error_message)
      Sentry.capture_message(error_message, level: :error, extra: { sts_number: @sts_number, result: result })
    end

    result_data = result["data"]
    return { raw_data: result } if result_data.empty?

    parsed_data = TrafficFines::ResponseParser.new(result_data).call
    { parsed_data: parsed_data, raw_data: result_data }
  rescue RequestError => e
    Sentry.capture_exception(e, extra: { service: 'TrafficFines', sts_number: @sts_number })
    raise e
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { service: 'TrafficFines', sts_number: @sts_number })
    raise RequestError, "Не удалось получить данные из сервиса штрафов: #{e.message}"
  end

  private

  def fetch_cookies
    TrafficFines::Request::FetchCookies.new.call
  end
end
