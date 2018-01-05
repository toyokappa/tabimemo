class CommentsController < ApplicationController
  def create
    plan = Plan.find(params[:comment][:plan_id])
    comment = plan.comments.build(comment_params)
    if comment.save
      redirect_to plan, notice: t("flash.comment_success")
    else
      redirect_to plan, alert: t("flash.comment_failed")
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    plan = comment.plan
    comment.destroy
    redirect_to plan, notice: t("flash.delete_success")
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :user_id)
    end
end
