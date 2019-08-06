require "redis"

Redis.current = Redis.new(host: ENV['REDIS_HOSTNAME'], port: ENV['REDIS_PORT'])
