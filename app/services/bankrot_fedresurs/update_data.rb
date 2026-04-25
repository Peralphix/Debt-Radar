# frozen_string_literal: true

class BankrotFedresurs::UpdateData
  def initialize(user)
    @user = user
  end

  def call
    return if @user.bankrot_updated_at && @user.bankrot_updated_at > 1.day.ago

    result = BankrotFedresurs::Search.new(@user.inn).call
    @user.update!(
      bankrot_parsed_data: result[:parsed_data].to_h,
      bankrot_raw_data: result[:raw_data].to_h,
      bankrot_updated_at: Time.current
    )
  rescue # как-нибудь изящнее потом сделать
    nil
  end
end
