class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :between_1_month, -> { self.where(created_at: [1.month.ago.beginning_of_day..Time.zone.now.end_of_day]) }
end
