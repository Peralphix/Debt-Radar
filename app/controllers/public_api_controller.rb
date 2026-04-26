# frozen_string_literal: true

class PublicApiController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false
  before_action :authenticate_internal_api!

  def check_user
    # binding.irb
    result = SearchAggregator.new(**debtor_params.to_h.deep_symbolize_keys).call
    #
    render json: { data: result }
    # render json: { data: debtor_params }
  end

  private

  def debtor_params
    params.require(:inn)
    params.permit(:inn, :full_name, :vin, :sts_number)
  end

  def authenticate_internal_api!
    token = request.headers["Authorization"].to_s.delete_prefix("Bearer ")

    head :unauthorized unless ActiveSupport::SecurityUtils.secure_compare(
      token,
      ENV.fetch("INTERNAL_API_TOKEN")
    )
  end
end
