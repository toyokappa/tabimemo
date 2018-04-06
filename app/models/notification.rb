class Notification < ApplicationRecord
  belongs_to :user, inverse_of: :notification
end
