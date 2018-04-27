class RefreshSitemapJob < ApplicationJob
  queue_as :default

  def perform
    if Rails.env.production?
      %x(bundle exec rails sitemap:refresh)
    else
      %x(bundle exec rails sitemap:refresh:no_ping)
    end
  end
end
