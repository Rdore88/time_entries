require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/focus'
require 'bundler/setup'
require "sqlite3"


class SqlTest < Minitest::Test

  def db
    SQLite3::Database.new "time_entries.sqlite3"
  end

  def test_find_all_time_entries
  sql = "SELECT * FROM time_entries"
  assert_equal 500, db.execute(sql).length
  end

end
