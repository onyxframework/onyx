require "db"
require "./utils/require_env"

runtime_env DATABASE_URL

module Onyx
  # Singleton `DB::Database` instance.
  # It **requires** `DATABASE_URL` environment variable to be set.
  # It would validate the connection on program run with
  # `Onyx.db.scalar("SELECT 1")` call, raising of failure.
  class_property db : DB::Database = DB.open(ENV["DATABASE_URL"])

  begin
    Onyx.db.scalar("SELECT 1")
  rescue ex : DB::ConnectionRefused
    raise "Cannot connect to DB at #{ENV["DATABASE_URL"]}"
  end
end
