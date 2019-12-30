class Users::RelationshipsController < ApplicationController
  def create
    follower = User.find_by!(name: params[:user_name])
    current_user.follow!(follower)
    redirect_back follback_location: user_profile_path(follower.name), success: "#{follower.display_name}をフォローしました"
  end

  def destroy
    follower = User.find_by!(name: params[:user_name])
    current_user.unfollow!(follower)
    redirect_back follback_location: user_profile_path(follower.name), success: "#{follower.display_name}のフォローを解除しました"
  end
end
