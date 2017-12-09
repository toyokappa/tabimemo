class Users::PasswordsController < ApplicationController
  before_action :set_current_user

  def edit
  end

  def update
    if @user.update_with_password(password_params)
      bypass_sign_in(@user)
      redirect_to root_path, notice: t("flash.update_success")
    else
      render "edit"
    end
  end

  private

    def set_current_user
      @user = current_user
    end

    def password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
end