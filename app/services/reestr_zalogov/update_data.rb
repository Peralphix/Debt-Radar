# frozen_string_literal: true

class ReestrZalogov::UpdateData
  def initialize(vehicle)
    @vehicle = vehicle
  end

  def call
    return if @vehicle.zalog_updated_at && @vehicle.zalog_updated_at > 1.day.ago

    result = ReestrZalogov::Search.new(@vehicle.vin).call.to_h
    @vehicle.update!(
      zalog_parsed_data: result[:parsed_data],
      zalog_raw_data: result[:raw_data],
      zalog_updated_at: Time.current
    )
  rescue # как-нибудь изящнее потом сделать
    nil
  end
end
