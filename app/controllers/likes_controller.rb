class LikesController < ApplicationController
  def create
    @plan = Plan.find(params[:plan_id])
    current_user.likes.create(plan: @plan)
    @plan.user.obtain_exp!
    if @plan.user != current_user && @plan.user.notification.when_like?
      LikeMailer.email(current_user, @plan).deliver
    end
    respond_to do |format|
      format.html { redirect_to @plan }
      format.js
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    current_user.likes.find_by(plan: @plan).destroy
    @plan.user.obtain_exp!
    respond_to do |format|
      format.html { redirect_to @plan }
      format.js
    end
  end
end
