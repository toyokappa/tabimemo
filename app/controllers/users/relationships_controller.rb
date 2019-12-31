class Users::RelationshipsController < ApplicationController
  def create
    follower = User.find_by!(name: params[:user_name])
    current_user.follow!(follower)
    follower.obtain_exp!
    follower.trophy.judge_follower_count!
    redirect_back fallback_location: user_profile_path(follower.name), notice: "#{follower.display_name}さんをフォローしました"
  end

  def destroy
    follower = User.find_by!(name: params[:user_name])
    current_user.unfollow!(follower)
    follower.obtain_exp!
    redirect_back fallback_location: user_profile_path(follower.name), notice: "#{follower.display_name}さんのフォローを解除しました"
  end
end
