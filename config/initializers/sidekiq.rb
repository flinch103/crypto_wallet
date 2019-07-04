Sidekiq.configure_server do |config|
  config.redis = { url: Figaro.env.REDIS_URL, id: nil }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Figaro.env.REDIS_URL, id: nil }
end
