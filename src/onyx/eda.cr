require "onyx-eda"
require "../onyx"

module Onyx
  # Top-level `Onyx::EDA::Channel` instance, `Onyx::EDA::Channel::Memory` by default.
  # To change the channel type, require it, for example `require "onyx/eda/redis"`.
  class_property channel : Onyx::EDA::Channel = Onyx::EDA::Channel::Memory.new

  # Call `Onyx::EDA::Channel#emit` on the `.channel`.
  def self.emit(*args, **nargs)
    channel.emit(*args, **nargs)
  end

  # Call `Onyx::EDA::Channel#subscribe` with *filter* on the `.channel`.
  def self.subscribe(event : T.class, **filter, &proc : T -> _) forall T
    channel.subscribe(T, **filter, &proc)
  end

  # Call `Onyx::EDA::Channel#subscribe` with *consumer_id* on the `.channel`.
  def self.subscribe(event : T.class, consumer_id : String, &proc : T -> _) forall T
    channel.subscribe(T, consumer_id, &proc)
  end

  # Call `Onyx::EDA::Channel#unsubscribe` on the `.channel`.
  def self.unsubscribe(*args, **nargs)
    channel.unsubscribe(*args, **nargs)
  end

  # Call `Onyx::EDA::Channel#await` with *proc* on the `.channel`.
  def self.await(event : T.class, **filter, &proc : T -> _) forall T
    channel.await(T, **filter, &proc)
  end

  # Call `Onyx::EDA::Channel#await` on the `.channel`.
  def self.await(event, **filter)
    channel.await(event, **filter)
  end

  # :nodoc:
  def self.await_select_action(
    event : T.class,
    **filter,
    &proc : T -> _
  ) forall T
    channel.await_select_action(T, **filter, &proc)
  end

  # :nodoc:
  def self.await_select_action(event, **filter)
    channel.await_select_action(event, **filter)
  end
end
