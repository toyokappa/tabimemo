class Like < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  scope :except_plan_user, -> { joins(:plan).where.not("likes.user_id = plans.user_id") }
end
