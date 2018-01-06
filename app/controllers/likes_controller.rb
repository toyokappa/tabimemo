class LikesController < ApplicationController
  def create
    @plan = Plan.find(params[:plan_id])
    current_user.likes.create(plan_id: @plan.id)
    respond_to do |format|
      format.html { redirect_to @plan }
      format.js
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    current_user.likes.find_by(plan_id: @plan).destroy
    respond_to do |format|
      format.html { redirect_to @plan }
      format.js
    end
  end
end
