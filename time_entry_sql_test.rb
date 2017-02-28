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

  def test_find_the_developer_who_joined_most_recently
    sql = "SELECT name, joined_on FROM developers ORDER BY joined_on DESC LIMIT 1"
    assert_equal ["Dr. Danielle McLaughlin", "2015-07-10"], db.execute(sql).first
  end

  def test_find_the_number_of_projects_for_each_client
    sql = "SELECT clients.name, client_id, COUNT(*) FROM projects INNER JOIN clients WHERE client_id = clients.id GROUP BY client_id"
    assert_equal ["West Group", 1, 3], db.execute(sql).first
  end

end
