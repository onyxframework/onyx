require "onyx-http"
require "../onyx"

runtime_env CRYSTAL_ENV

module Onyx
  {% for method in Onyx::HTTP::Middleware::Router::HTTP_METHODS %}
    # Define a {{method.upcase.id}} route with block for the top-level `.router`.
    # See `HTTP::Router#{{method.id}}`.
    def self.{{method.id}}(*args, **nargs, &block : ::HTTP::Server::Context -> Nil)
      Onyx::HTTP::Singleton.instance.router.{{method.id}}(*args, **nargs, &block)
    end

    # Define a {{method.upcase.id}} route for the top-level `.router`.
    # See `HTTP::Router#{{method.id}}`.
    def self.{{method.id}}(*args, **nargs)
      Onyx::HTTP::Singleton.instance.router.{{method.id}}(*args, **nargs)
    end
  {% end %}

  # Define a "ws://" route with block for the top-level `.router`.
  # See `HTTP::Router#ws`.
  def self.ws(*args, **nargs, &block : ::HTTP::WebSocket, ::HTTP::Server::Context -> Nil)
    Onyx::HTTP::Singleton.instance.router.ws(*args, **nargs, &block)
  end

  # ditto
  def self.ws(*args, **nargs)
    Onyx::HTTP::Singleton.instance.router.ws(*args, **nargs)
  end

  # Draw routes for the top-level `.router`.
  # See `HTTP::Router#draw`.
  def self.draw(&block)
    with Onyx::HTTP::Singleton.instance.router yield
  end

  # The top-level `HTTP::Router` instance.
  def self.router
    Onyx::HTTP::Singleton.instance.router
  end

  # Render a template at *path* into *io* with [Kilt](https://github.com/jeromegn/kilt).
  #
  # ```
  # Onyx.render(env.response, "./hello.html.ecr")
  # # Expands to
  # Kilt.embed("./hello.html.ecr", env.response)
  # ```
  macro render(io, path)
    Kilt.embed({{path}}, {{io}})
  end

  def self.renderer=(value)
    HTTP::Singleton.instance.renderer = value
  end

  def self.renderer
    HTTP::Singleton.instance.renderer
  end

  # Instantiate an `Onyx::HTTP::Server`, bind it to the *host* and *port* and start listening.
  # Routes for it are defined with top-level `Onyx.get` methods and its siblings.
  #
  # You can insert your custom code into the `&block`.
  # At this point, `handlers` variable will be available.
  macro listen(host = "127.0.0.1", port = 5000, reuse_port = false, **handler_options, &block)
    handlers = Onyx::HTTP::Singleton.instance.handlers({{handler_options.double_splat}})
    {{yield.id}}
    server = Onyx::HTTP::Server.new(handlers, logger: Onyx.logger)
    server.bind_tcp({{host}}, {{port}}, reuse_port: {{reuse_port}})
    server.listen
  end

  module HTTP
    # The singleton instance of an Onyx HTTP server wrapper.
    # It is **not** initialized unless called.
    class Singleton
      # The singleton instance.
      def self.instance
        @@instance ||= new
      end

      @router = Middleware::Router.new

      # The singleton `HTTP::Router` instance.
      property router

      @renderer : ::HTTP::Handler = Middleware::Renderer.new(
        verbose: !%w(production benchmarking).includes?(ENV["CRYSTAL_ENV"]),
      )

      # The singleton renderer instance.
      property renderer

      # The default set of handlers. See its source code to find out which handlers in particular.
      # You can in theory modify these handlers in the `Onyx.listen` block.
      def handlers(cors = nil)
        if ENV["CRYSTAL_ENV"] == "benchmarking"
          [
            Middleware::Rescuer::Silent(Exception).new(renderer),
            Middleware::Rescuer::Error.new(renderer),
            router,
            renderer,
          ].compact!
        else
          [
            Middleware::ResponseTime.new,
            Middleware::RequestID.new,
            Middleware::Logger.new(
              Onyx.logger,
              query: ENV["CRYSTAL_ENV"] != "production"
            ),
            cors ? Middleware::CORS.new(**cors) : Middleware::CORS.new,
            Middleware::Rescuer::Standard(Exception).new(
              renderer,
              Onyx.logger,
              verbose: true, # Always be verbose with unhandled exceptions
            ),
            Middleware::Rescuer::Error.new(renderer),
            router,
            renderer,
          ].compact!
        end
      end
    end
  end
end
