class Plan < ApplicationRecord
  extend Enumerize
  enumerize :status, in: { draft: 0, published: 1 }, scope: true, predicates: true

  belongs_to :user
  has_many :spots, -> { order(:position) }, inverse_of: :plan, dependent: :destroy
  accepts_nested_attributes_for :spots, reject_if: :all_blank, allow_destroy: true
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
end
