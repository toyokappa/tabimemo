class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :content, presence: true, length: { maximum: 1000 }

  scope :except_plan_user, -> { joins(:plan).where.not("comments.user_id = plans.user_id") }
end
