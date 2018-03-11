class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.mail.info
  layout "mailer"
end
