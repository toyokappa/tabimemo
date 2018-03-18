class ApplicationMailer < ActionMailer::Base
  add_template_helper(ActionView::Helpers::UrlHelper)
  default from: Rails.configuration.x.mail.noreply
  layout "mailer"
end
