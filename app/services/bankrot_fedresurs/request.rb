# frozen_string_literal: true

class BankrotFedresurs::Request
  URL = 'https://bankrot.fedresurs.ru/backend/prsnbankrupts'

  def initialize(inn)
    @inn = inn.to_s
  end

  def call
    response = HTTP.headers(headers).get(URL, params: params)
    JSON.parse(response.body.to_s) if response.status.success?
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { service: 'BankrotFedresurs', inn: @inn })
    nil
  end

  private

  def params
    {
      searchString: @inn,
      isActiveLegalCase: 'null',
      limit: 15,
      offset: 0
    }
  end

  def headers
    {
      'Accept' => 'application/json, text/plain, */*',
      'Accept-Language' => 'ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7',
      'Referer' => "https://bankrot.fedresurs.ru/bankrupts?searchString=#{@inn}&regionId=all&isActiveLegalCase=null&offset=0&limit=15",
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36'
    }
  end
end
