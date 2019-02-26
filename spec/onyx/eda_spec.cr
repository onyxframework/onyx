require "../spec_helper"
require "../../src/onyx/eda"

struct TestEvent
  include Onyx::EDA::Event

  getter foo

  def initialize(@foo : String)
  end
end

describe "onyx/eda" do
  test_string = ""

  Onyx.subscribe(Object, TestEvent) do |event|
    test_string = event.foo
  end

  Onyx.emit(TestEvent.new("bar"))

  sleep(0.1)

  it do
    test_string.should eq "bar"
  end

  Onyx.unsubscribe(Object)
end
