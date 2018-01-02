class LikesController < ApplicationController
  def create
    plan = Plan.find(params[:plan_id])
    Like.create(user_id: current_user.id, plan_id: plan.id)
    redirect_to plan_path(plan)
  end

  def destroy
    plan = Plan.find(params[:id])
    Like.find_by(user_id: current_user, plan_id: plan).destroy
    redirect_to plan_path(plan)
  end
end
