class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plans = Plan.published.limit(8)
    @pop_plans = Plan.with_popular.limit(8)
  end
end
