# frozen_string_literal: true

class TrafficFines::UpdateJob < ApplicationJob
  queue_as :default

  def perform(vehicle, sts_number)
    TrafficFines::UpdateData.new(vehicle, sts_number).call
  end
end
