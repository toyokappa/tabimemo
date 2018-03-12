class OpinionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    opinion = Opinion.new(opinion_params)
    if opinion.valid? && OpinionMailer.email(opinion).deliver
      redirect_to root_path, notice: t("flash.mail_success")
    else
      redirect_to root_path, alert: t("flash.mail_success")
    end
  end

  private
    def opinion_params
      params.require(:opinion).permit(:user, :email, :content)
    end
end
