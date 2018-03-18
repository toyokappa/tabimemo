class CommentMailer < ApplicationMailer
  def email(comment, plan)
    @comment = comment
    @plan = plan
    mail to: @plan.user.email, bcc: Rails.configuration.x.mail.to, subject: "【Tabimemo】プランへコメントがつきました"
  end
end
