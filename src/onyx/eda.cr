require "onyx-eda"
require "../onyx"

module Onyx
  # Top-level `Onyx::EDA::Channel` instance. It's in-memory by default.
  # To change the channel type, use `Onyx.channel(type)` macro.
  class_property channel : Onyx::EDA::Channel = Onyx::EDA::Channel.new

  # Call `Onyx::EDA::Channel#emit` on the `.channel`.
  def self.emit(*args, **nargs)
    channel.emit(*args, **nargs)
  end

  # Call `Onyx::EDA::Channel#subscribe` on the `.channel`.
  def self.subscribe(object, event : T.class, &proc : T -> Nil) forall T
    channel.subscribe(object, event, &proc)
  end

  # Call `Onyx::EDA::Channel#unsubscribe` on the `.channel`.
  def self.unsubscribe(object, event : T.class, &proc : T -> Nil) forall T
    channel.unsubscribe(object, event, &proc)
  end

  # ditto
  def self.unsubscribe(*args, **nargs)
    channel.unsubscribe(*args, **nargs)
  end

  # Change the `Onyx.channel` type.
  # The only valid value is `redis`.
  #
  # NOTE: It must be called **before** any event is declared.
  #
  # ```
  # require "onyx/eda"
  #
  # Onyx.channel(:redis)
  #
  # struct MyEvent
  #   include Onyx::EDA::Event
  # end
  #
  # # ...
  # ```
  macro channel(type)
    {% if type.id == "redis".id %}
      require "onyx/env"
      require "onyx-eda/channel/redis"

      runtime_env REDIS_URL

      Onyx.channel = Onyx::EDA::Channel::Redis.new(ENV["REDIS_URL"])
    {% else %}
      {% raise %Q[Unknown EDA channel #{type} (valid value is "redis")] %}
    {% end %}
  end
end
