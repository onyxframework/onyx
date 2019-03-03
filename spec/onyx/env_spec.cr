require "../spec_helper"
require "../../src/onyx/env"

runtime_env FOO, :FOO, "FOO"

describe "onyx/env" do
  it do
    ENV["CRYSTAL_ENV"].should eq "development"
    ENV["FOO"].should eq "bar"
  end
end
