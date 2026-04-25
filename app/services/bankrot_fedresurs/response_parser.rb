# frozen_string_literal: true

class BankrotFedresurs::ResponseParser
  KEYS = %i[snils category region address lastLegalCase fio].freeze

  def initialize(data)
    @data = data
  end

  def call
    @data.deep_symbolize_keys.slice(*KEYS)
  end
end
