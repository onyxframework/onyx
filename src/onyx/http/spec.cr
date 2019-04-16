require "../http"

module Onyx::HTTP
  macro listen(host = "127.0.0.1", port = 3000, reuse_port = false, **handler_options, &block)
    handlers = Onyx::HTTP::Singleton.instance.handlers({{handler_options.double_splat}})

    {{yield.id}}

    server = Onyx::HTTP::Server.new(handlers, logger: Onyx.logger)
    server.bind_tcp({{host}}, {{port}}, reuse_port: {{reuse_port}})

    spawn server.listen
    sleep(0.1)

    Onyx::HTTP::Spec.client = ::HTTP::Client.new(URI.new("http", {{host}}, {{port}}))
  end

  # HTTP testing module. It helps to test your Onyx application.
  # `require "onyx/http/spec"` **before** your application, so it
  # spawn a server instead of blocking on `Onyx::HTTP.listen`.
  module Spec
    class_property! client : ::HTTP::Client

    {% for method in Onyx::HTTP::Middleware::Router::HTTP_METHODS %}
      # Send `{{method.id.upcase}}` request to the Onyx server and
      # return `ResponseWrapper`.
      #
      # ```
      # require "onyx/http/spec"
      # require "../my_server"
      #
      # it "returns 200 OK" do
      #   response = Onyx::HTTP::Spec.get("/foo")
      #   response.assert(200, "OK")
      # end
      # ```
      def self.{{method.id}}(*args, **nargs)
        response = client.{{method.id}}(*args, **nargs)
        return ResponseWrapper.new(response)
      end
    {% end %}

    # Initialize a new websocket connection to the Onyx server
    # and return `WebSocketWrapper`.
    #
    # ```
    # require "onyx/http/spec"
    # require "../my_server"
    #
    # it "echoes" do
    #   socket = Onyx::HTTP::Spec.ws("/echo")
    #   socket.assert_response("hello", "hello")
    # end
    # ```
    def self.ws(path : String, headers : ::HTTP::Headers = ::HTTP::Headers.new)
      socket = ::HTTP::WebSocket.new(client.host, path, client.port, headers: headers)
      spawn socket.run
      return WebSocketWrapper.new(socket)
    end

    class ResponseWrapper
      # Direct response accessor, if needed.
      getter response : ::HTTP::Client::Response

      def initialize(@response)
      end

      # Assert response *status_code*.
      def assert(status_code : Int)
        @response.status_code.should eq status_code
      end

      # Assert response *status_code* and *body*.
      def assert(status_code : Int, body : String)
        assert(status_code)
        @response.body.should eq body
      end

      # Assert response *status_code*, *body* and *headers*.
      def assert(status_code : Int, body : String, headers : Hash(String, String))
        assert(status_code, body)
        @response.headers.should eq headers
      end
    end

    class WebSocketWrapper
      # Direct socket accessor, if needed.
      getter socket : ::HTTP::WebSocket

      def initialize(@socket)
      end

      # Assert socket response. It sends *request*, *wait*s and asserts
      # the response to be equal to *expected*.
      def assert_response(
        request : String | Bytes,
        expected : String | Bytes,
        wait : Time::Span | Number = 0.1.seconds
      )
        response : String | Bytes | Nil = nil

        if expected.is_a?(String)
          @socket.on_message do |message|
            response = message
          end
        else
          @socket.on_binary do |bytes|
            response = bytes
          end
        end

        @socket.send(request)
        sleep(wait)

        response.should eq expected
      end
    end
  end
end
