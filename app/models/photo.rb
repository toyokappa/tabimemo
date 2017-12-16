class Photo < ApplicationRecord
  belongs_to :spot
  mount_uploader :image, PhotoUploader

  # validate :max_file_size

  def self.create_photos_by(photo_params)
    Photo.transaction do
      photo_params.each do |index|
        spot = Spot.find(photo_params[index][:id])
        photo_params[index][:photos]&.each do |photo|
          return false unless spot.photos.create!(image: photo)
        end
      end
    end
  end
  private

    # def max_file_size
    #   if image.size > 5.megabytes
    #     errors.add(:image, I18n.t("errors.messages.max_file_size_error"))
    #   end
    # end
end
