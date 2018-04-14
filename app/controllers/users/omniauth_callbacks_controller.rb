class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!

  def twitter
    callback_from :twitter
  end

  private

    def callback_from(provider)
      provider = provider.to_s
      @user = User.find_for_oauth(request.env["omniauth.auth"])

      if @user.persisted?
        flash[:notice] = t("devise.omniauth_callbacks.registered", kind: provider.capitalize)
        sign_in_and_redirect @user, event: :authentication
      elsif @user.present?
        flash.now[:notice] = t("devise.omniauth_callbacks.success", kind: provider.capitalize)
        render "users/registrations/new"
      else
        redirect_to new_user_registration_path, alert: t("devise.omniauth_callbacks.faild", kind: provider.capitalize)
      end
    end
end
