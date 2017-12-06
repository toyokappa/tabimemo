class Profile < ApplicationRecord
  extend Enumerize

  belongs_to :user, foreign_key: "id"

  enumerize :gender, in: { male: 0, female: 1 }
end
