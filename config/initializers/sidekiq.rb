Sidekiq.configure_server do |config|
  config.redis =  { url: "redis://#{URI.parse(ENV["REDIS"])}", namespace: "sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis =  { url: "redis://#{URI.parse(ENV["REDIS"])}", namespace: "sidekiq_#{Rails.env}" }
end
