class Users::ProfilesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :liked]
  before_action :set_user, only: [:show, :liked]
  before_action :set_profile, only: [:edit, :update]
  before_action :set_meta, only: [:show]

  def show
    @profile = @user.profile
    @plans = @user.plans.published
    respond_to do |format|
      format.html
      format.js { render "plan_list" }
    end
  end

  def liked
    @plans = @user.liked_plans
    respond_to do |format|
      format.js { render "plan_list" }
    end
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
      when "show" then
        title = @user.profile.name.present? ? "#{@user.profile.name}さん" : "#{@user.name}さん"
        set_common_meta(:title, title)
        set_common_meta(:description, @user.profile.description) if @user.profile.description.present?
        set_common_meta(:image, @user.profile.image.url) if @user.profile.image.present?
      end
    end
end
