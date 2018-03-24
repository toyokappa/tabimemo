class Users::PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :update, :destroy]
  before_action :is_current_user?, only: [:edit, :update, :destroy]

  def index
    @plans = current_user.plans.management_order.page(params[:page])
    respond_to do |format|
      format.html
      format.js { render "plan_list" }
    end
  end

  def published
    @plans = current_user.plans.published.management_order.page(params[:page])
    respond_to do |format|
      format.js { render "plan_list" }
    end
  end

  def draft
    @plans = current_user.plans.draft.management_order.page(params[:page])
    respond_to do |format|
      format.js { render "plan_list" }
    end
  end

  def new
    @plan = current_user.plans.build
  end

  def create
    @plan = current_user.plans.build(new_plan_params)
    if @plan.save
      redirect_to edit_users_plan_path(@plan, init: true)
    else
      render "new"
    end
  end

  def edit
    @plan.spots.create if @plan.spots.blank?
  end

  def update
    if params[:published]
      @plan.status = :published
      @plan.published_at = Time.zone.now if @plan.published_at.blank?
    elsif params[:draft]
      @plan.status = :draft
    end

    if @plan.update(edit_plan_params)
      if params[:sortable]
        redirect_to edit_users_plan_path(@plan), notice: t(:sort_success, scope: :flash)
      else
        redirect_to plan_path(@plan), notice: t(:update_success, scope: :flash)
      end
    else
      flash.now[:alert] = t(:register_failed, scope: :flash)
      render "edit"
    end
  end

  def destroy
    @plan.destroy!
    redirect_to users_plans_path, notice: t(:delete_success, scope: :flash)
  end

  def suggest_spot
    key = Rails.configuration.x.google_apis[:map]
    input = params[:input]

    # オートコンプリート用のクエリ
    url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    params = URI.encode_www_form({ key: key, input: input})
    uri = URI.parse "#{url}#{params}"

    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    body = JSON.load response.body
    place_ids = body["predictions"].map { |prediction| prediction["place_id"] }

    render json: place_ids
  end

  def translate_spot
    key = Rails.configuration.x.google_apis[:map]
    placeid = params[:placeid]

    # プレイス詳細用のクエリ(GoogleのAPIがアドレスを日本語で返却してくれないため、一時的に対応)
    url = "https://maps.googleapis.com/maps/api/place/details/json?"
    params = URI.encode_www_form({ key: key, placeid: placeid, language: :ja })
    uri = URI.parse "#{url}#{params}"

    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https")do |http|
      http.request(request)
    end

    body = JSON.load response.body
    result = body["result"]
    if result.present?
      address = result["formatted_address"]
      address.slice!(/^日本、〒[0-9]{3}-[0-9]{4}\s/)
      place = { name: result["name"], address: address, lat: result["geometry"]["location"]["lat"], lng: result["geometry"]["location"]["lng"] }
      render json: place
    else
      render json: ""
    end
  end

  private

    def new_plan_params
      params.require(:plan).permit(:name, :description)
    end

    def edit_plan_params
      params.require(:plan).permit(:name, :description, spots_attributes: [:id, :name, :description, :address, :latitude, :longitude, :position, :_destroy, photos_attributes: [:id, :position, :is_header, :_destroy]])
    end

    def set_plan
      @plan = current_user.plans.find(params[:id])
    end

    def is_current_user?
      redirect_to root_path unless @plan.user == current_user
    end
end
