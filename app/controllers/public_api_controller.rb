# frozen_string_literal: true

class PublicAPIController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def check_user
    result = SearchAggregator.new(**debtor_params).call

    render json: { data: result }
  end

  private

  def debtor_params
    params.require(:inn)
    params.permit(:inn, :full_name, :vin, :sts_number)
  end
end
