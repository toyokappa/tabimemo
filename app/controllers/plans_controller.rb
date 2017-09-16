class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = Plan.all
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
      render "new"
    end
  end

  def edit
    @plan.spots.build
  end

  def update
    if @plan.update
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
      params.require(:plan).permit(:name, :description, spots_attributes[:id, :name, :description, :_destroy])
    end

    def set_plan
      @plan = Plan.find(params[:id])
    end
end
