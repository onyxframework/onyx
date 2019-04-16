require "../eda"
require "onyx-eda/channel/redis"

runtime_env REDIS_URL

module Onyx::EDA
  # Singleton [`Onyx::EDA::Channel::Redis`](https://api.onyxframework.org/eda/Onyx/EDA/Channel/Redis.html) instance.
  #
  # NOTE: It **requires** `REDIS_URL` environment variable to be set.
  #
  # `require "onyx/eda/redis"` to enable it.
  class_getter redis = Onyx::EDA::Channel::Redis.new(
    uri: ENV["REDIS_URL"],
    logger: (Onyx.logger unless ENV["CRYSTAL_ENV"] == "benchmarking"),
    logger_severity: ::Logger::Severity::DEBUG
  )
end
