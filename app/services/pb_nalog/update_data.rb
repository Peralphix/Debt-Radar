# frozen_string_literal: true

class PbNalog::UpdateData
  def initialize(user)
    @user = user
  end

  def call
    return if @user.nalog_updated_at && @user.nalog_updated_at > 1.day.ago

    result = PbNalog::Search.new(@user.inn).call
    @user.update!(
      # наверное, обновлять не стоит, если данные более-менее актуальны, но в этот раз пришли с ошибкой
      nalog_parsed_data: result[:parsed_data].to_h,
      nalog_raw_data: result[:raw_data].to_h,
      nalog_updated_at: Time.current
    )
  rescue # как-нибудь изящнее потом сделать
    nil
  end
end
