class Spot < ApplicationRecord
  belongs_to :plan
  mount_uploaders :photos, PhotoUploader

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
  validate :photos_file_size

  private

    def photos_file_size
      photos.each do |photo|
        if photo.size > 5.megabytes
          errors.add(:photos, I18n.t("errors.messages.min_size_error"))
        end
      end
    end
end
