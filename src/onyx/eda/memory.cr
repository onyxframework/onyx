require "../eda"
require "onyx-eda/channel/memory"

module Onyx::EDA
  # Singleton [`Onyx::EDA::Channel::Memory`](https://api.onyxframework.org/eda/Onyx/EDA/Channel/Memory.html) instance.
  #
  # `require "onyx/eda/memory"` to enable it.
  class_getter memory = Onyx::EDA::Channel::Memory.new
end
