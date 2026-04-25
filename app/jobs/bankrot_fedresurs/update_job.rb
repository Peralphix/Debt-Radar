# frozen_string_literal: true

class BankrotFedresurs::UpdateJob < ApplicationJob
  queue_as :default

  def perform(user, inn)
    BankrotFedresurs::UpdateData.new(user, inn).call
  end
end
