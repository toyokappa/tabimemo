class Users::SocialAccountsController < ApplicationController
  def destroy
    social_account = SocialAccount.find(params[:id])
    social_account.destroy!
    redirect_to edit_user_registration_path, notice: t("devise.omniauth_callbacks.release_connection", kind: social_account.provider.capitalize)
  end
end
