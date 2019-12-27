class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)

    # エラー時のレンダリング用
    @plan = @comment.plan
    @photo = @plan.photos.first
    @user = @plan.user
    @like = current_user.likes.find_by(plan_id: @plan)
    @comments = @plan.comments
    @pv = @plan.total_pv

    if @comment.save
      @user.trophy.judge_comment_count!
      if @plan.user != current_user && @plan.user.notification.when_comment?
        CommentMailer.email(@comment, @plan).deliver
      end
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
