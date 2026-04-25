# frozen_string_literal: true

class PbNalog::ResponseParser
  def initialize(response)
    @response = response
  end

  def call
    serialized_response
  end

  private

  def serialized_response
    {
      company_name: @response['namec'],
      region: @response['regionname'],
      ogrn: @response['ogrn'],
      registration_data: @response['dtreg'],
      okved_name: @response['okved2name'], # Название кода ОКВЭД-2
    }
  end
end
