# frozen_string_literal: true

class PbNalog::Request::SearchId
  def initialize(inn)
    @inn = inn.to_s
  end

  def call
    parsed_body = JSON.parse(response_body)

    if parsed_body["captchaRequired"] == true
      raise CaptchaRequiredError, "Unable to get data from PB Nalog."
    end

    parsed_body["id"]
  end

  private

  def response_body
    HTTP.headers(headers).post(url, form: payload).body.to_s
  end

  def payload
    {
      mode: 'search-all',
      queryAll: @inn,
      mspUl1: 1, mspUl2: 1, mspUl3: 1,
      mspIp1: 1, mspIp2: 1, mspIp3: 1,
      uprType1: 1, uprType0: 1,
      ogrFl: 1,
      ogrUl: 1,
      npTypeDoc: 1,
      page: 1,
      pageSize: 10
    }
  end

  def headers
    {
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '\
        'AppleWebKit/537.36 (KHTML, like Gecko) '\
        'Chrome/120.0 Safari/537.36'
    }
  end

  def url
    "https://pb.nalog.ru/search-proc.json"
  end
end
