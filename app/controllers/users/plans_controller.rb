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
    @plan.status = params[:draft] ? :draft : :published
    if @plan.spots.each {|spot| spot.create_photos_by(photo_params[:spots_attributes])} && @plan.update(edit_plan_params)
      redirect_to plan_path(@plan), notice: t(:update_success, scope: :flash)
    else
      render "edit"
    end
  end

  def destroy
    @plan.destroy!
    redirect_to users_plans_path, notice: t(:delete_success, scope: :flash)
  end

  def create_spot
    plan = Plan.find(params[:plan_id])
    @spot = plan.spots.create
    render json: @spot.id
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

  def set_geometry
    url = "https://maps.googleapis.com/maps/api/place/details/json?"
    key = "AIzaSyDBlYdxJipM-Gablze4G84BoPagcYp4k-8"
    place_id = params[:place_id]
    params = URI.encode_www_form({ key: key, place_id: place_id })
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
      params.require(:plan).permit(:name, :description, spots_attributes: [:id, :name, :description, :latitude, :longitude, :_destroy, photos_attributes: [:id, :_destroy]])
    end

    def photo_params
      params.require(:plan).permit(spots_attributes: [:id, :_destroy, { photos: [] }])
    end

    def set_plan
      @user = current_user
      @plan = @user.plans.find(params[:id])
    end

    def is_current_user?
      redirect_to root_path unless @plan.user == current_user
    end
end
