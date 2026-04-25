# frozen_string_literal: true

class PbNalog::Request::Result
  def initialize(search_id)
    @search_id = search_id.to_s
  end

  def call
    JSON.parse(response_body)
  end

  private

  def response_body
    HTTP.headers(headers).post(url, form: payload).body.to_s
  end

  def payload
    {
      id: @search_id,
      method: "get-response",
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
