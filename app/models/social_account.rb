class SocialAccount < ApplicationRecord
  belongs_to :user

  validates :uid, uniqueness: { scope: :provider }
  validates :user_id, uniqueness: { scope: :provider }
end
