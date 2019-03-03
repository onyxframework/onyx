require "./http"
require "onyx-rest"

module Onyx
  # Select a renderer for `Onyx::REST` singleton server instance. Can be `:text`, `:json`,
  # `:template` or a name of a [Kilt](https://github.com/jeromegn/kilt)-compatible
  # template shard (e.g. `:slang`).
  #
  # NOTE: You must add a template dependency in your `shard.yml` unless it's `:ecr`.
  macro render(type, *, verbose = ENV["CRYSTAL_ENV"]? != "production", **options, &block)
    {% if type.id == "json".id %}
      require "onyx-rest/renderer/json"
      Onyx::HTTP::Singleton.instance.renderer = Onyx::REST::Renderer::JSON.new(verbose: {{verbose}}).as(HTTP::Handler)
    {% elsif type.id == "text".id %}
      require "onyx-rest/renderer/text"
      Onyx::HTTP::Singleton.instance.renderer = Onyx::REST::Renderer::Text.new(verbose: {{verbose}}).as(HTTP::Handler)
    {% else %}
      {% unless type.id == "ecr".id || type.id == "template".id %}
        require "kilt/{{type.id}}"
      {% end %}

      require "onyx-rest/renderer/template"

      {% if block %}
        %renderer = Onyx::REST::Renderer::Template.new(verbose: {{verbose}}{{", #{options.double_splat}".id unless options.empty?}}) do {{("|" + block.args.map(&.stringify).join(", ") + "|").id unless block.args.empty?}}
            {{yield.id}}
          end
        Onyx::HTTP::Singleton.instance.renderer = %renderer.as(HTTP::Handler)
      {% else %}
        Onyx::HTTP::Singleton.instance.renderer = Onyx::REST::Renderer::Template.new(verbose: {{verbose}}{{", #{options.double_splat}".id unless options.empty?}}).as(HTTP::Handler)
      {% end %}
    {% end %}
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

  module HTTP
    class Singleton
      @renderer : ::HTTP::Handler | Nil = nil

      # The singleton renderer instance.
      property renderer

      def handlers(cors = nil)
        [
          HTTP::ResponseTime.new,
          HTTP::RequestID.new,
          HTTP::Logger.new(
            Onyx.logger,
            query: ENV["CRYSTAL_ENV"]? != "production"
          ),
          cors ? HTTP::CORS.new(**cors) : HTTP::CORS.new,
          HTTP::Rescuers::Standard(Exception).new(renderer),
          HTTP::Rescuers::RouteNotFound.new(renderer),
          REST::Rescuer.new(renderer),
          router,
          renderer,
        ].compact!
      end
    end
  end
end
