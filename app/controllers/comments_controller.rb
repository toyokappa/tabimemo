class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)

    # エラー時のレンダリング用
    @plan = @comment.plan
    @photo = @plan.photos.first
    @user = @plan.user
    @like = current_user.likes.find_by(plan_id: @plan)
    @comments = @plan.comments
    @pv = @plan.show_pv + @plan.page_views.sum(:count)

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
