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
    ac_url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    ac_params = URI.encode_www_form({ key: key, input: input})
    ac_uri = URI.parse "#{ac_url}#{ac_params}"

    ac_request = Net::HTTP::Get.new(ac_uri.request_uri)
    ac_response = Net::HTTP.start(ac_uri.host, ac_uri.port, use_ssl: ac_uri.scheme == "https") do |http|
      http.request(ac_request)
    end

    ac_body = JSON.load ac_response.body
    place_ids = ac_body["predictions"].map { |prediction| prediction["place_id"] }

    # プレイス詳細用のクエリ(GoogleのAPIがアドレスを日本語で返却してくれないため、一時的に対応)
    pd_url = "https://maps.googleapis.com/maps/api/place/details/json?"
    places = place_ids.map do |placeid|
      pd_params = URI.encode_www_form({ key: key, placeid: placeid, language: :ja })
      pd_uri = URI.parse "#{pd_url}#{pd_params}"

      pd_request = Net::HTTP::Get.new(pd_uri.request_uri)
      pd_response = Net::HTTP.start(pd_uri.host, ac_uri.port, use_ssl: ac_uri.scheme == "https")do |http|
        http.request(pd_request)
      end

      pd_body = JSON.load pd_response.body
      pd_result = pd_body["result"]
      if pd_result.present?
        address = pd_result["formatted_address"]
        address.slice!(/^日本、〒[0-9]{3}-[0-9]{4}\s/)
        { name: pd_result["name"], address: address, lat: pd_result["geometry"]["location"]["lat"], lng: pd_result["geometry"]["location"]["lng"] }
      end
    end

    render json: places.compact
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
