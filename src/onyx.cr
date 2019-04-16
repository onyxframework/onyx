# Singletons and macros for eaiser development.
#
# # Cheatsheet:
#
# `require "onyx/env"` to read from `.env.*`, `.env.*.local` variables
# `require "onyx/logger"` to enable `Onyx.logger`
# `require "onyx"` to require both above
# `require "onyx/db"` to enable singleton `Onyx.db` (automatically required
# with `"onyx/sql"`)
#
# `"onyx"` is required by default in all the components below,
# so you don't have to require it explicitly.
#
# ## HTTP
#
# `require "onyx/http"` to enable the singleton HTTP server instance and these methods:
#
# * `Onyx::HTTP.get`, `Onyx::HTTP.post`, `Onyx::HTTP.put`,
# `Onyx::HTTP.patch`, `Onyx::HTTP.delete` and `Onyx::HTTP.options`
# * `Onyx::HTTP.draw`
# * `Onyx::HTTP.listen`
#
# ## SQL
#
# `require "onyx/sql"` to enable singleton `Onyx.repo` instance and `Onyx::SQL.query`,
# `Onyx::SQL.exec`, `Onyx::SQL.scalar` and `Onyx::SQL.transaction` methods.
#
# ## EDA
#
# `require "onyx/eda/memory"` and/or `require "onyx/eda/redis"` to enable singleton
# channel instance and according methods, for example, `Onyx::EDA.memory.subscribe`.
module Onyx
end

require "./onyx/env"
require "./onyx/logger"

if ENV["CRYSTAL_ENV"] == "benchmarking"
  puts " ONYX ".colorize(:black).back(:white).mode(:bold).to_s + " Running in \"benchmarking\" environment — all output is muted"
end
