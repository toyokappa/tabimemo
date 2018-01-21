class Users::SpotsController < ApplicationController
  def create
    plan = Plan.find(params[:plan_id])
    @spot = plan.spots.create
    render json: @spot.id
  end
end
