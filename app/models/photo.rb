class Photo < ApplicationRecord
  belongs_to :spot
  mount_uploaders :photos, PhotoUploader

  validate :max_file_size

  private

    def max_file_size
      if image.size > 5.megabytes
        errors.add(:image, I18n.t("errors.messages.max_file_size_error"))
      end
    end
end
