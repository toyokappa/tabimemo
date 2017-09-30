class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = Plan.page(params[:page])
  end

  def show
  end

  def new
    @plan = Plan.new
    @plan.spots.build
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      redirect_to plan_path(@plan), notice: t(:register_success, scope: :flash)
    else
      @plan.spots.build
      render "new"
    end
  end

  def edit
    @plan.spots.build
  end

  def update
    if @plan.update(plan_params)
      redirect_to plan_path(@plan), notice: t(:update_success, scope: :flash)
    else
      @plan.spots.build
      render "edit"
    end
  end

  def destroy
    @plan.destroy!
    redirect_to root_url, notice: t(:delete_success, scope: :flash)
  end

  private

    def plan_params
      params.require(:plan).permit(:name, :description, spots_attributes: [:id, :name, :description, :_destroy, {photos: []}])
    end

    def set_plan
      @plan = Plan.find(params[:id])
    end
end
