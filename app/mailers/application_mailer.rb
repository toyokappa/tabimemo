class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.mail.noreply
  layout "mailer"
end
