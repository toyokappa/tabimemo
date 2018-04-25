class Users::PasswordsController < ApplicationController
  before_action :set_current_user
  before_action :redirect_to_new_password, only: [:edit, :update]
  before_action :redirect_to_edit_password, only: [:new, :create]

  def new
  end

  def create
    if @user.update(new_password_params)
      bypass_sign_in(@user)
      redirect_to root_path, notice: t("flash.register_success")
    else
      render "new"
    end
  end

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

    def new_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end

    def redirect_to_new_password
      redirect_to new_users_password_path if current_user.encrypted_password.blank?
    end

    def redirect_to_edit_password
      redirect_to edit_users_password_path if current_user.encrypted_password.present?
    end
end
