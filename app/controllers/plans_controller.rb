class PlansController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plans = Plan.published.page(params[:page])
  end

  def show
    @plan = Plan.find(params[:id])
    @photo = @plan.spots.map { |spot| spot.photos }.flatten.first
    @user = @plan.user
    @like = current_user&.likes&.find_by(plan_id: @plan)
    @comment = current_user&.comments&.build
    @comments = @plan.comments
    redirect_to root_path unless @plan.published? || @user == current_user
  end
end
