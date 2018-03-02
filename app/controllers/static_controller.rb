class StaticController < ApplicationController
  skip_before_action :authenticate_user!
  
  def terms
  end

  def privacy_policy
  end
end
