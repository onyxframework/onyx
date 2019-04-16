require "../eda"
require "onyx-eda/channel/memory"

module Onyx::EDA
  class_getter memory = Onyx::EDA::Channel::Memory.new
end
