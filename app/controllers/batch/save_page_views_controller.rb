class Batch::SavePageViewsController < Batch::ApplicationController
  def create
    SavePageViewsJob.perform_now
    render json: "ok"
  end
end
