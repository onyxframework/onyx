require "onyx-sql"
require "../onyx"
require "./db"

runtime_env CRYSTAL_ENV

module Onyx::SQL
  # Singleton `Onyx::SQL::Repository instance`.
  # Has `Onyx.db` as a *db* and and `Onyx.logger` as a *logger*.
  class_property repo : Onyx::SQL::Repository = Onyx::SQL::Repository.new(
    Onyx.db,
    if ENV["CRYSTAL_ENV"] == "benchmarking"
      Onyx::SQL::Repository::Logger::Dummy.new
    else
      Onyx::SQL::Repository::Logger::Standard.new(Onyx.logger, ::Logger::Severity::DEBUG)
    end
  )

  # Call `#query` on the singleton `.repo` instance.
  def self.query(*args, **nargs)
    repo.query(*args, **nargs)
  end

  # Call `#exec` on the singleton `.repo` instance.
  def self.exec(*args, **nargs)
    repo.exec(*args, **nargs)
  end

  # Call `#scalar` on the singleton `.repo` instance.
  def self.scalar(*args, **nargs)
    repo.scalar(*args, **nargs)
  end
end
