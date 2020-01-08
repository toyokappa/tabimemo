class RefreshSitemapJob < ApplicationJob
  queue_as :default

  def perform
    %x(bundle exec rails sitemap:refresh) if Rails.env.production?
  end
end
