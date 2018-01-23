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
    @plan.spots.create if @plan.spots.blank?
  end

  def update
    @plan.status = :published if params[:published]
    @plan.status = :draft if params[:draft]
    if @plan.update(edit_plan_params)
      if params[:sortable]
        redirect_to edit_users_plan_path(@plan), notice: t(:update_success, scope: :flash)
      else
        redirect_to plan_path(@plan), notice: t(:update_success, scope: :flash)
      end
    else
      render "edit"
    end
  end

  def destroy
    @plan.destroy!
    redirect_to users_plans_path, notice: t(:delete_success, scope: :flash)
  end

  def suggest_spot
    url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    key = "AIzaSyDBlYdxJipM-Gablze4G84BoPagcYp4k-8"
    input = params[:input]
    params = URI.encode_www_form({ key: key, input: input })
    uri = URI.parse "#{url}#{params}"

    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    body = JSON.parse response.body
    render json: body
  end

  private

    def new_plan_params
      params.require(:plan).permit(:name, :description)
    end

    def edit_plan_params
      params.require(:plan).permit(:name, :description, spots_attributes: [:id, :name, :description, :latitude, :longitude, :position, :_destroy, photos_attributes: [:id, :_destroy]])
    end

    def set_plan
      @user = current_user
      @plan = @user.plans.find(params[:id])
    end

    def is_current_user?
      redirect_to root_path unless @plan.user == current_user
    end
end
