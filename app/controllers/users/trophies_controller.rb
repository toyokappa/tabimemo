class Users::TrophiesController < ApplicationController
  def show
    @user = User.find_by!(name: params[:user_name])
    @trophy = @user.trophy
  end
end
