class Users::ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update]

  def show
  end

  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      redirect_to users_profile_path, notice: t("flash.register_success")
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to users_profile_path, notice: t("flash.update_success")
    else
      render "edit"
    end
  end

  private

    def profile_params
      params.require(:profile).permit(:name, :description, :location, :url, :gender, :birthday)
    end

    def set_profile
      @profile = current_user.profile
    end
end
