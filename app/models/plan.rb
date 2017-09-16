class Plan < ApplicationRecord
  has_many :spots, inverse_of: :plan
  accepts_nested_attributes_for :spots, reject_if: lambda { |attributes| attributes["name"].blank? }, allow_destroy: true

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
end
