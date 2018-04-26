class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!

  def twitter
    if user_signed_in?
      connect_to :twitter
    else
      callback_from :twitter
    end
  end

  private

    def callback_from(provider)
      provider = provider.to_s
      @user = User.find_for_oauth(request.env["omniauth.auth"])

      if @user.persisted?
        flash[:notice] = t("devise.omniauth_callbacks.registered", kind: provider.capitalize)
        sign_in_and_redirect @user, event: :authentication
      elsif User.find_by(email: @user.email).present?
        redirect_to new_user_session_path, alert: t("devise.omniauth_callbacks.already_registered", kind: provider.capitalize)
      elsif @user.present?
        flash.now[:notice] = t("devise.omniauth_callbacks.success", kind: provider.capitalize)
        render "users/registrations/new"
      else
        redirect_to new_user_registration_path, alert: t("devise.omniauth_callbacks.faild", kind: provider.capitalize)
      end
    end

    def connect_to(provider)
      provider = provider.to_s
      auth = request.env["omniauth.auth"]
      social_account = current_user.social_accounts.build(uid: auth.uid, provider: auth.provider)
      if social_account.save
        redirect_to edit_user_registration_path, notice: t("devise.omniauth_callbacks.success_connection", kind: provider.capitalize)
      else
        redirect_to edit_user_registration_path, alert: t("devise.omniauth_callbacks.already_used", kind: provider.capitalize)
      end
    end
end
