# frozen_string_literal: true

class PbNalog::UpdateJob < ApplicationJob
  queue_as :default

  def perform(user, inn)
    PbNalog::UpdateData.new(user, inn).call
  end
end
