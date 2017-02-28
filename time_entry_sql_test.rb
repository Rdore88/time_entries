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
    sql = "SELECT clients.name, client_id, COUNT(*) FROM projects INNER JOIN clients
    WHERE client_id = clients.id GROUP BY client_id"
    assert_equal ["West Group", 1, 3], db.execute(sql).first
  end

  def test_find_all_time_entries_and_show_each_ones_client_name_next_to_it
    sql = "SELECT clients.name, time_entries.id, developer_id, project_id, worked_on, duration,
    time_entries.created_at, time_entries.updated_at FROM time_entries INNER JOIN projects
    ON time_entries.project_id = projects.id INNER JOIN clients ON projects.client_id = clients.id"
    assert_equal ["Eichmann, Altenwerth and Morar", 1, 1, 24, "2014-07-20", 5, "2015-07-14 16:15:18.437386", "2015-07-14 16:15:18.437386"], db.execute(sql).first
  end

  def test_find_all_developers_in_the_Ohio_sheep_group
    sql = "SELECT developers.name FROM developers INNER JOIN group_assignments
    ON developers.id = group_assignments.developer_id INNER JOIN groups
    ON group_assignments.group_id = groups.id WHERE groups.name = 'Ohio sheep'"
    assert_equal ["Bruce Wisoky Jr."], db.execute(sql).first
  end

  def test_find_the_total_number_of_hours_worked_for_each_client
    sql = "SELECT  SUM(duration), clients.name FROM time_entries INNER JOIN projects
    ON time_entries.project_id = projects.id INNER JOIN clients ON projects.client_id = clients.id
    GROUP BY clients.id"
    assert_equal [176, "West Group"], db.execute(sql).first
  end

  def test_lupe_most_hours_worked_for_client
    sql = "SELECT SUM(duration), developers.name, clients.name FROM developers INNER JOIN time_entries
    ON developers.id = time_entries.developer_id INNER JOIN projects ON time_entries.project_id = projects.id
    INNER JOIN clients ON projects.client_id = clients.id WHERE developers.name = 'Mrs. Lupe Schowalter'
    GROUP BY clients.id ORDER BY SUM(duration) DESC LIMIT 1"
    assert_equal [11, "Mrs. Lupe Schowalter", "Kuhic-Bartoletti"], db.execute(sql).first
  end

  def test_client_names_and_project_names
    sql = "SELECT clients.name, projects.name FROM clients LEFT JOIN projects ON clients.id = projects.client_id"
    assert_equal 33, db.execute(sql).length
  end

  def test_developers_who_have_no_comments
    sql = "SELECT developers.name, comments.comment FROM developers LEFT JOIN comments
    ON developers.id = comments.developer_id WHERE comments.comment IS NULL"
    assert_equal 13, db.execute(sql).length
  end

  def test_developers_who_have_at_least_five_comments
    sql = "SELECT developers.name FROM developers LEFT JOIN comments
    ON developers.id = comments.developer_id GROUP BY comments.developer_id HAVING COUNT(comments.developer_id) >= 5"
    assert_equal ["Joelle Hermann"], db.execute(sql).first
  end

end
# , developers.name
