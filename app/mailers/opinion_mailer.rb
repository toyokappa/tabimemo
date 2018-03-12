class OpinionMailer < ApplicationMailer
  def email(opinion)
    @opinion = opinion
    mail to: Rails.configuration.x.mail.to, subject: t("opinion.mail.subject")
  end
end
