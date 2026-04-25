# frozen_string_literal: true

class KadArbitr::UpdateJob < ApplicationJob
  queue_as :default

  def perform(user, inn)
    KadArbitr::UpdateData.new(user, inn).call
  end
end
