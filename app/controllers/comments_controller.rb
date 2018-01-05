class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to comment.plan, notice: t("flash.comment_success")
    else
      redirect_to comment.plan, alert: t("flash.comment_failed")
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to comment.plan, notice: t("flash.delete_success")
  end

  private

    def comment_params
      params.require(:comment).permit(:content, :plan_id)
    end
end
