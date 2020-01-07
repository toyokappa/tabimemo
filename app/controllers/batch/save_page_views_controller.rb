class Batch::SavePageViewsController < Batch::ApplicationController
  def create
    SavePageViewsJob.perform_later
    render json: "ok"
  end
end
