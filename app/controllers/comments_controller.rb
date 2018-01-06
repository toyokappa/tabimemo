class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)

    # エラー時のレンダリング用
    @plan = @comment.plan
    @user = @plan.user
    @like = current_user.likes.find_by(plan_id: @plan)
    @comments = @plan.comments

    if @comment.save
      redirect_to @plan, notice: t("flash.comment_success")
    else
      render "plans/show"
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
