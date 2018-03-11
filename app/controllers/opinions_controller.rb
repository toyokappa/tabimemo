class OpinionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    opinion = Opinion.new(opinion_params)
    if opinion.valid? && OpinionMailer.email(opinion).deliver
      redirect_to root_path, notice: "ご意見ボックスを送信しました"
    else
      redirect_to root_path, alert: "ご意見ボックスの送信に失敗しました"
    end
  end

  private
    def opinion_params
      params.require(:opinion).permit(:user, :email, :content)
    end
end
