class Users::RelationshipsController < ApplicationController
  def create
    follower = User.find_by!(name: params[:user_name])
    current_user.follow!(follower)
    redirect_back fallback_location: user_profile_path(follower.name), notice: "#{follower.display_name}さんをフォローしました"
  end

  def destroy
    follower = User.find_by!(name: params[:user_name])
    current_user.unfollow!(follower)
    redirect_back fallback_location: user_profile_path(follower.name), notice: "#{follower.display_name}さんのフォローを解除しました"
  end
end
