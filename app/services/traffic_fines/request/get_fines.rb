# frozen_string_literal: true

class TrafficFines::Request::GetFines
  URL = "https://www.mos.ru/shtrafy/api/penalties/"
  MAX_RETRIES = 2

  def initialize(sts_number, cookies: nil)
    @sts_number = sts_number.to_s
    @cookies = cookies
  end

  def call
    response = HTTP.headers(headers).post(URL, json: payload)

    unless response.status.success?
      raise BaseSearch::RequestError, "Traffic Fines API error: #{response.status}"
    end

    JSON.parse(response.body.to_s)
  end

  private

  def payload
    {
      documentType: 'nomer_sts',
      documentNumber: @sts_number
    }
  end

  def headers
    {
      'accept' => 'application/json',
      'accept-language' => 'ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7',
      'content-type' => 'application/json',
      'origin' => 'https://www.mos.ru',
      'priority' => 'u=1, i',
      'referer' => 'https://www.mos.ru/shtrafy/list/',
      'sec-ch-ua' => '"Not:A-Brand";v="99", "Google Chrome";v="145", "Chromium";v="145"',
      'sec-ch-ua-mobile' => '?0',
      'sec-ch-ua-platform' => '"macOS"',
      'sec-fetch-dest' => 'empty',
      'sec-fetch-mode' => 'cors',
      'sec-fetch-site' => 'same-origin',
      'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36',
      'x-caller-id' => 'shtrafy::service',
      'cookie' => @cookies
    }.compact
  end
end
