class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plans = Plan.published.limit(9)
    @pop_plans = Plan.with_popular.limit(9)
    @following_plans = current_user.following_plans.limit(9) if user_signed_in?
  end
end
