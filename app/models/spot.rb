class Spot < ApplicationRecord
  belongs_to :plan

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
end
