require "pg"
require "../spec_helper"
require "../../src/onyx/sql"

describe "Onyx::SQL" do
  describe ".transaction" do
    Onyx::SQL.transaction do |tx|
      Onyx::SQL.scalar("SELECT 1").as(Int32).should eq 1
    end

    Onyx::SQL.transaction do |tx|
      Onyx::SQL.scalar("SELECT 1").as(Int32).should eq 1
      tx.commit
    end

    Onyx::SQL.transaction do |tx|
      Onyx::SQL.scalar("SELECT 1").as(Int32).should eq 1
      tx.rollback
    end
  end
end
