require "../eda"
require "onyx-eda/channel/redis"

runtime_env REDIS_URL

Onyx.channel = Onyx::EDA::Channel::Redis.new(ENV["REDIS_URL"])
