class Profile < ApplicationRecord
  extend Enumerize
  enumerize :gender, in: { male: 0, female: 1 }
  mount_uploader :image, ProfileImageUploader

  before_create -> { self.id = user.id }
  belongs_to :user, foreign_key: "id"

  URL_FORMAT = /\A#{URI::regexp(%w(http https))}\z/
  validates :url, format: URL_FORMAT
  validate :max_file_size

  private

    def max_file_size
      if image.size > 5.megabytes
        errors.add(:image, I18n.t("errors.messages.max_file_size_error"))
      end
    end
end
