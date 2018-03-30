class Batch::SavePageViewsController < BatchController
  def exec
    SavePageViewsJob.perform_now
    render json: "ok"
  end
end
