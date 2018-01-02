class LikesController < ApplicationController
  def create
    @plan = Plan.find(params[:plan_id])
    Like.create(user_id: current_user.id, plan_id: @plan.id)
    respond_to do |format|
      format.html { redirect_to @plan }
      format.js
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    Like.find_by(user_id: current_user, plan_id: @plan).destroy
    respond_to do |format|
      format.html { redirect_to @plan }
      format.js
    end
  end
end
