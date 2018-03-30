class BatchController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :basic_auth

  def basic_auth
    authenticate_or_request_with_http_basic("Application") do |name, password|
      _name = ENV["BATCH_USERNAME"] || "tabimemouser"
      _pass = ENV["BATCH_PASSWORD"] || "tabimemopass"
      name == _name && password == _pass
    end
  end
end
