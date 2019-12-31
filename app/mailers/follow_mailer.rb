class FollowMailer < ApplicationMailer
  def email(follower)
    @follower = follower
    mail to: @follower.email, bcc: Rails.configuration.x.mail.to, subject: "【Tabimemo】#{@follower.display_name}さんからフォローされました"
  end
end
