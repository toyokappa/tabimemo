class LikeMailer < ApplicationMailer
  def email(like, plan)
    @like = like
    @plan = plan
    mail to: @plan.user.email, bcc: Rails.configuration.x.mail.to, subject: t("likes.mail.subject")
  end
end
