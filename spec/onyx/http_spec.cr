require "../spec_helper"
require "../../src/onyx/http"
require "../../src/onyx/http/spec"

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

Onyx::HTTP.get "/" do |env|
  env.response << "Hello Onyx"
end

Onyx::HTTP.on do |r|
  r.on "/foo" do
    r.on "/:bar" do
      r.get "/" do |env|
        env.response << "Hello from /foo/#{env.request.path_params["bar"]}"
      end
    end
  end
end

Onyx::HTTP.ws "/echo" do |socket|
  socket.on_message do |message|
    socket.send(message)
  end
end

Onyx::HTTP.post "/endpoint", TestEndpoint

Onyx::HTTP.listen

describe "onyx/http" do
  describe "/" do
    it "returns 200 Hello Onyx" do
      response = Onyx::HTTP::Spec.get("/")
      response.assert(200, "Hello Onyx")
    end
  end

  describe "/foo/bar" do
    it "returns 200 Hello from /foo/bar" do
      response = Onyx::HTTP::Spec.get("/foo/baz")
      response.assert(200, "Hello from /foo/baz")
    end
  end

  describe "/endpoint" do
    it "returns 200 foo=bar" do
      response = Onyx::HTTP::Spec.post("/endpoint", headers: HTTP::Headers{"Content-Type" => "application/x-www-form-urlencoded"}, body: "foo=bar")
      response.assert(200, "foo = bar")
    end
  end

  describe "ws://echo" do
    it "echoes" do
      socket = Onyx::HTTP::Spec.ws("/echo")
      socket.assert_response("ping", "ping")
    end
  end
end
