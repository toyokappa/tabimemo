class PlansController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plans = Plan.where(published: true).page(params[:page])
  end
end
