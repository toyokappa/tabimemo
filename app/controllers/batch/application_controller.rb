class Batch::ApplicationController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :basic_auth
  protect_from_forgery

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      _username = ENV["BATCH_USERNAME"] || "tabimemouser"
      _password = ENV["BATCH_PASSWORD"] || "tabimemopass"
      username == _username && password == _password
    end
  end
end
