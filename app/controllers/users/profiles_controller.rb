class Users::ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :like, :trophy, :followers, :following]
  before_action :set_user, only: [:show, :like, :trophy, :followers, :following]
  before_action :set_profile, only: [:edit, :update]
  before_action :set_meta, only: [:show]

  def show
    @plans = @user.plans.published
  end

  def like
    @plans = @user.liked_plans
    render :show
  end

  def trophy
    @trophy = @user.trophy
  end

  def followers
    @follow_users = @user.followers.order(created_at: :desc)
    render :follow_list
  end

  def following
    @follow_users = @user.following.order(created_at: :desc)
    render :follow_list
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to user_profile_path(current_user.name), notice: t("flash.update_success")
    else
      render "edit"
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:name, :description, :location, :url, :gender, :birthday, :image)
    end

    def set_user
      @user = User.find_by!(name: params[:user_name])
    end

    def set_profile
      @profile = current_user.profile
    end

    def set_meta
      case action_name
      when "show"
        title = @user.profile.name.present? ? "#{@user.profile.name}さん" : "#{@user.name}さん"
        set_common_meta(:title, title)
        set_common_meta(:description, @user.profile.description) if @user.profile.description.present?
        set_common_meta(:image, @user.profile_image_url) if @user.profile.image.present?
      end
    end
end
