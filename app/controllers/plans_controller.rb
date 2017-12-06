class PlansController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plans = Plan.where(published: true).page(params[:page])
  end

  def show
    @plan = Plan.find(params[:id])
    redirect_to root_path unless @plan.published?
  end
end
