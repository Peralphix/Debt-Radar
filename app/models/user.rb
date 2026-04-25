class User < ApplicationRecord
  has_many :vehicles, dependent: :destroy

  validates :full_name, presence: true
  validates :inn,
            presence: true,
            format: {
              with: /\A(\d{10}|\d{12})\z/,
              message: "должен содержать 10 или 12 цифр"
            },
            uniqueness: true
end
