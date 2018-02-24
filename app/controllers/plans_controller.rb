class PlansController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if params[:type] == "popular"
      @plans = Plan.with_popular.page(params[:page])
    else
      @plans = Plan.published.page(params[:page])
    end
  end

  def show
    @plan = Plan.find(params[:id])
    @photo = @plan.spots.map { |spot| spot.photos }.flatten.first
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
end
