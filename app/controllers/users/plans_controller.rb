class Users::PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :update, :destroy]
  before_action :is_current_user?, only: [:edit, :update, :destroy]

  def index
    @user = current_user
    @plans = @user.plans.page(params[:page])
  end

  def new
    @plan = current_user.plans.build
    @plan.spots.build
  end

  def create
    user = current_user
    @plan = user.plans.build(new_plan_params)
    if @plan.save
      redirect_to edit_users_plan_path(@plan)
    else
      render "new"
    end
  end

  def edit
    @plan.spots.build if @plan.spots.blank?
  end

  def update
    @plan.published = params[:draft] ? false : true
    if @plan.update(edit_plan_params)
      redirect_to plan_path(@plan), notice: t(:update_success, scope: :flash)
    else
      render "edit"
    end
  end

  def destroy
    @plan.destroy!
    redirect_to users_plans_path, notice: t(:delete_success, scope: :flash)
  end

  private

    def new_plan_params
      params.require(:plan).permit(:name, :description, :published)
    end

    def edit_plan_params
      params.require(:plan).permit(:name, :description, spots_attributes: [:id, :name, :description, :_destroy, photos_attributes: [:id, { image: [] }, :image_cache, :_destroy]])
    end

    def set_plan
      @user = current_user
      @plan = @user.plans.find(params[:id])
    end

    def is_current_user?
      redirect_to root_path unless @plan.user == current_user
    end
end