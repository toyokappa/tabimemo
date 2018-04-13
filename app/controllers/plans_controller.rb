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
    @photo = @plan.get_header_image
    @user = @plan.user
    @like = current_user&.likes&.find_by(plan_id: @plan)
    @comment = current_user&.comments&.build
    @comments = @plan.comments
    @pv = @plan.show_pv + @plan.page_views.sum(:count)
    redirect_to root_path if @plan.draft? && @user != current_user

    if @user != current_user
      @plan.increment_pv
    end
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
        set_common_meta(:image, @plan.get_header_image.image.url)
        set_meta_tags keyword: @plan.spots.map(&:name).join(", ")
      end
    end
end
