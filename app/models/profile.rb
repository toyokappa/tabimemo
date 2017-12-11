class Profile < ApplicationRecord
  extend Enumerize

  before_create -> { self.id = user.id }
  mount_uploader :image, ImageUploader
  belongs_to :user, foreign_key: "id"
  enumerize :gender, in: { male: 0, female: 1 }
end
