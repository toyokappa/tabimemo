class ApplicationController < ActionController::Base
  include MetaSetter
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_search

  private
    def set_search
      @keyword = params[:q] ? params[:q][:keyword_all] : ""
      @search = Plan.ransack(params[:q])
      @results = @search.result.default_order.distinct.page(params[:page])
    end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |u|
        u.permit(:name, :email, :password,
                 :password_confirmation, :agreement,
                 :remember_me, :uid, :provider,
                 social_accounts_attributes: [:id, :provider, :uid],
                 profile_attributes: [:id, :name, :description, :location, :url, :remote_image_url]
                )
      end
      devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:login, :name, :email, :password, :remember_me) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email) }
    end
end
