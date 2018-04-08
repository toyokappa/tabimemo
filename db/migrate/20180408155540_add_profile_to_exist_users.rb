class AddProfileToExistUsers < ActiveRecord::Migration[5.1]
  def up
    Profile.transaction do
      User.find_each do |user|
        user.create_profile if user.profile.nil?
      end
    end
  end
end
