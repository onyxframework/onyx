require "../spec_helper"
require "../../src/onyx/http"

struct TestView
  include Onyx::HTTP::View

  def initialize(@foo : String)
  end

  text "foo = #{@foo}"
end

struct TestEndpoint
  include Onyx::HTTP::Endpoint

  params do
    form do
      type foo : String
    end
  end

  def call
    TestView.new(params.form.not_nil!.foo)
  end
end

Onyx.get "/" do |env|
  env.response << "Hello Onyx"
end

Onyx.post "/endpoint", TestEndpoint

spawn do
  Onyx.listen(port: 4890)
end

sleep(0.1)

describe "onyx/rest" do
  client = HTTP::Client.new(URI.parse("http://localhost:4890"))

  it do
    response = client.get "/"
    response.status_code.should eq 200
    response.body.should eq "Hello Onyx"
  end

  it do
    response = client.post("/endpoint", headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"}, body: "foo=bar")
    response.status_code.should eq 200
    response.body.should eq "foo = bar"
  end
end
