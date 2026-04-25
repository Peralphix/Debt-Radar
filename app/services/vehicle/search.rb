# frozen_string_literal: true

class Vehicle::Search
  def initialize(customer, vin, sts_number)
    @customer = customer
    @vin = vin
    @sts_number = sts_number
  end

  def call
    return if @vin.blank? && @sts_number.blank?

    vehicle = find_vehicle
    if vehicle
      vehicle.update!(vin: @vin, sts_number: @sts_number)
    else
      vehicle = @customer.vehicles.create!(vin: @vin, sts_number: @sts_number)
    end

    vehicle
  end

  private

  def find_vehicle
    @customer.vehicles.where(vin: @vin).first ||
      @customer.vehicles.where(sts_number: @sts_number).first
  end
end
