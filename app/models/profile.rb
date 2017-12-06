class Profile < ApplicationRecord
  belongs_to :user, foreign_key: "id"

  enum gender: { male: 0, female: 1 }
end
