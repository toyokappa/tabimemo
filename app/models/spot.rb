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
          errors.add(:photos, "のファイルサイズは5MBまでです。")
        end
      end
    end
end
