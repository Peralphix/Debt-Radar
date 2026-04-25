# frozen_string_literal: true

class KadArbitr::UpdateData
  def initialize(user)
    @user = user
  end

  def call
    return if @user.kad_arbitr_updated_at && @user.kad_arbitr_updated_at > 1.day.ago

    result = KadArbitr::Search.new(@user.inn).call.to_h
    @user.update!(
      kad_arbitr_parsed_data: result[:parsed_data],
      kad_arbitr_raw_data: result[:raw_data],
      kad_arbitr_updated_at: Time.current
    )
  rescue # как-нибудь изящнее потом сделать
    nil
  end
end
