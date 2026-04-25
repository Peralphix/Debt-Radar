# frozen_string_literal: true

class TrafficFines::Request::FetchCookies
  URL = "https://www.mos.ru/shtrafy/"

  def call
    fetch_cookies
  end

  private

  def fetch_cookies
    response = HTTP.get(URL)
    cookies = response.cookies.map { |cookie| "#{cookie.name}=#{cookie.value}" }.join('; ')
    cookies.empty? ? nil : cookies
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { service: 'TrafficFines', method: 'fetch_cookies' })
    nil
  end
end
