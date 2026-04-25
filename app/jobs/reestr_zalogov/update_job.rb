# frozen_string_literal: true

class ReestrZalogov::UpdateJob < ApplicationJob
  queue_as :default

  def perform(vehicle, vin)
    ReestrZalogov::UpdateData.new(vehicle, vin).call
  end
end
