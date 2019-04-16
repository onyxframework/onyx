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

  # Put the `.repo`'s current database connection into  transaction mode and yield
  # that [`DB::Transaction`](http://crystal-lang.github.io/crystal-db/api/0.5.1/DB/Transaction.html) object.
  #
  # All repository requests would be made within the transaction.
  # The transaction is closed after the yield unless it's explicitly closed before
  # (i.e. committed or rolled back).
  #
  # ```
  # Onyx::SQL.transaction do |tx|
  #   Onyx.query(User.where(id: 1)) # Request is made within the transaction
  #   tx.connection                 # You have access to the raw `DB::Connection` instance
  # end
  # ```
  def self.transaction(&block : ::DB::Transaction ->)
    previous_db = repo.db

    repo.db.transaction do |tx|
      repo.db = tx.connection
      yield(tx)
      tx.close unless tx.closed?
      repo.db = previous_db
    end
  end
end
