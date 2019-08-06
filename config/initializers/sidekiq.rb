Sidekiq.configure_server do |config|
  config.redis =  { url: "redis://#{Rails.configuration.x.redis_url}", namespace: "sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis =  { url: "redis://#{Rails.configuration.x.redis_url}", namespace: "sidekiq_#{Rails.env}" }
end
