class Users::SpotsController < ApplicationController
  def create
    plan = Plan.find(params[:plan_id])
    @spot = plan.spots.create(position: params[:position])
    render json: @spot.id
  end
end
