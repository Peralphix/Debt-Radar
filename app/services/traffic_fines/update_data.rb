# frozen_string_literal: true

class TrafficFines::UpdateData
  def initialize(vehicle)
    @vehicle = vehicle
  end

  def call
    return if @vehicle.traffic_fines_updated_at && @vehicle.traffic_fines_updated_at > 1.day.ago

    result = TrafficFines::Search.new(@vehicle.sts_number).call
    return if result.blank?

    @vehicle.update!(
      traffic_fines_parsed_data: result[:parsed_data].to_h,
      traffic_fines_raw_data: result[:raw_data].to_h,
      traffic_fines_updated_at: Time.current
    )
  rescue # как-нибудь изящнее потом сделать
    nil
  end
end
