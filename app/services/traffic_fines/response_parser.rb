# frozen_string_literal: true

class TrafficFines::ResponseParser
  def initialize(data)
    @data = data || []
  end

  def call
    @data.map { |fine| parse_fine(fine) }
  end

  private

  def parse_fine(fine)
    {
      total_amount: fine["totalAmount"],
      amount_to_pay: fine["amountToPay"],
      bill_date: fine["billDate"],
      bill_for: fine["billFor"],
      offence_date: fine.dig("offence", "date"),
      offence_place: fine.dig("offence", "place"),
      offence_legal_act: fine.dig("offence", "legalAct"),
      department: fine.dig("offence", "departmentName"),
    }
  end
end
