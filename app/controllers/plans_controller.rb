class PlansController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :is_current_user?, only: [:edit, :update, :destroy]

  def index
    @plans = Plan.page(params[:page])
  end

  def show
  end

  def new
    @plan = current_user.plans.build
    @plan.spots.build
  end

  def create
    @plan = current_user.plans.build(plan_params)
    if @plan.save
      redirect_to plan_path(@plan), notice: t(:register_success, scope: :flash)
    else
      @plan.spots.build
      render "new"
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      redirect_to plan_path(@plan), notice: t(:update_success, scope: :flash)
    else
      render "edit"
    end
  end

  def destroy
    @plan.destroy!
    redirect_to root_url, notice: t(:delete_success, scope: :flash)
  end

  private

    def plan_params
      params.require(:plan).permit(:name, :description, spots_attributes: [:id, :name, :description, :_destroy, :photos_cache, { photos: [] }])
    end

    def set_plan
      @plan = Plan.find(params[:id])
    end

    def is_current_user?
      redirect_to root_path unless @plan.user == current_user
    end
end
