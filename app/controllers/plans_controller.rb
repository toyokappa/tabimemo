class PlansController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_plan, only: [:show]
  before_action :set_meta

  def index
    if params[:type] == "popular"
      @plans = Plan.with_popular.page(params[:page])
    else
      @plans = Plan.published.page(params[:page])
    end
  end

  def show
    return redirect_to root_path if @plan.draft? && @plan.user != current_user

    @plan.increment_pv if @plan.user != current_user
    @photo = @plan.get_header_image
    @user = @plan.user
    @like = @plan.likes.find_by(user: current_user)
    @comment = current_user&.comments&.build
    @comments = @plan.comments
  end

  private

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def set_meta
      case action_name
      when "index" then
        title = params[:type] == "popular" ? t(".popular_plans") : t(".latest_plans")
        set_common_meta(:title, title)
      when "show" then
        set_common_meta(:title, @plan.name)
        set_common_meta(:description, @plan.description)
        set_common_meta(:image, @plan.get_header_image.image.url) if @plan.get_header_image.present?
        set_meta_tags keyword: @plan.spots.map(&:name).join(", ")
      end
    end
end
