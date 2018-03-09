class SearchController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if @keyword.blank? || @keyword.match?(/\n"　"/)
      @keyword = ""
      @plans = Plan.published.limit(8)
      @pop_plans = Plan.with_popular.limit(8)
      render "welcome/index"
    end
  end
end
