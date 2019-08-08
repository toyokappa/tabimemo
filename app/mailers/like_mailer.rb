class LikeMailer < ApplicationMailer
  def email(user, plan)
    @user = user
    @plan = plan
    mail to: @plan.user.email, bcc: Rails.configuration.x.mail.to, subject: t("likes.mail.subject")
  end
end
