require "logger"
require "./utils/custom_log_formatter"
require "./utils/require_env"

runtime_env CRYSTAL_ENV

module Onyx
  # The singleton `Logger` instance. It has a custom slim formatter and
  # level depending on `CRYSTAL_ENV` environment variable:
  #
  # * `"production"` -- `INFO`
  # * `"benchmarking"` -- `FATAL`, outputs to `dev/null`
  # * all other (including `nil`) -- `DEBUG`
  #
  # ```
  # require "onyx/logger"
  # Onyx.logger.debug("Hello world!")
  # # DEBUG [12:45:52.520 #13543] Hello world!
  # ```
  class_property logger : Logger = Logger.new(
    ENV["CRYSTAL_ENV"] == "benchmarking" ? File.open(File::NULL, "w") : STDOUT,
    case ENV["CRYSTAL_ENV"]
    when "benchmarking" then Logger::FATAL
    when "production"   then Logger::INFO
    else                     Logger::DEBUG
    end,
    formatter: custom_log_formatter,
  )
end
