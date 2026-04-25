# frozen_string_literal: true

class SearchAggregator
  def initialize(full_name:, birthdate:, inn:, vin:, sts_number:)
    @full_name = full_name
    @birthdate = birthdate
    @inn = inn
    @vin = vin
    @sts_number = sts_number
  end

  def call
    user = User::Search.new(@full_name, @birthdate, @inn).call
    vehicle = Vehicle::Search.new(user, @vin, @sts_number).call

    # binding.irb
    threads = []

    # Пользовательские данные
    threads << Thread.new { BankrotFedresurs::UpdateData.new(user).call }
    # threads << Thread.new { KadArbitr::UpdateData.new(user, @inn).call }
    threads << Thread.new { PbNalog::UpdateData.new(user).call }

    # Данные по транспорту
    if vehicle
      threads << Thread.new { TrafficFines::UpdateData.new(vehicle).call } # переделать потом на джобы
      # threads << Thread.new { ReestrZalogov::UpdateData.new(vehicle, @vin).call }
    end

    threads.each(&:join)

    KadArbitr::UpdateData.new(user).call
    ReestrZalogov::UpdateData.new(vehicle).call

    # binding.irb
    {
      user: user.reload.attributes,
      vehicle: vehicle&.reload&.attributes,
    }

  rescue => e
    puts "Проблема с парсингом данных: #{e}"
    # этот хэндл потом убрать, оставив рескью только в запросах
  end
end
