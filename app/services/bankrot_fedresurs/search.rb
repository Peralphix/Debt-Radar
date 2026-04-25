# frozen_string_literal: true

class BankrotFedresurs::Search < BaseSearch
  def initialize(inn)
    @inn = inn.to_s
  end

  def call
    result = BankrotFedresurs::Request.new(@inn).call
    raise RequestError, "Не удалось получить данные из сервиса Bankrot Fedresurs" if result.nil?

    result_data = result["pageData"]&.first
    return { raw_data: result } if result_data.blank?

    parsed_data = BankrotFedresurs::ResponseParser.new(result_data).call
    { parsed_data:, raw_data: result_data }
  rescue RequestError => e
    Sentry.capture_exception(e, extra: { service: 'BankrotFedresurs', inn: @inn })
    raise e
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { service: 'BankrotFedresurs', inn: @inn })
    raise RequestError, "Произошла ошибка при обращении к сервису Bankrot Fedresurs"
  end
end
