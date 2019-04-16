require "../eda"
require "onyx-eda/channel/redis"

runtime_env REDIS_URL

module Onyx::EDA
  class_getter redis = Onyx::EDA::Channel::Redis.new(
    uri: ENV["REDIS_URL"],
    logger: (Onyx.logger unless ENV["CRYSTAL_ENV"] == "benchmarking"),
    logger_severity: ::Logger::Severity::DEBUG
  )
end
