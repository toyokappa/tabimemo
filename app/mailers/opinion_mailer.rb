class OpinionMailer < ApplicationMailer
  def email(opinion)
    @opinion = opinion
    mail to: Rails.configuration.x.mail.info, subject: "【お知らせ】ご意見ボックスが投稿されました"
  end
end
