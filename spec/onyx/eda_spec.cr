require "../spec_helper"
require "../../src/onyx/eda/memory"

struct TestEvent
  include Onyx::EDA::Event

  getter foo

  def initialize(@foo : String)
  end
end

describe "onyx/eda/memory" do
  test_string = ""

  sub = Onyx::EDA.memory.subscribe(TestEvent) do |event|
    test_string = event.foo
  end

  Onyx::EDA.memory.emit(TestEvent.new("bar"))

  sleep(0.1)

  it do
    test_string.should eq "bar"
  end

  sub.unsubscribe
end
