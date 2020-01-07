class Batch::SavePageViewsController < Batch::ApplicationController
  def exec
    SavePageViewsJob.perform_now
    render json: "ok"
  end
end
