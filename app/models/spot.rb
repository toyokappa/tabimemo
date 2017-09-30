class Spot < ApplicationRecord
  belongs_to :plan
  mount_uploaders :photos, PhotoUploader

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
end
