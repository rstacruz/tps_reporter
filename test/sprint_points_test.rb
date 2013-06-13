require File.expand_path('../test_helper', __FILE__)

class SprintPointsTest < UnitTest
  setup do
    @list = TPS::TaskList.new :yaml => f('sprint_points.yml')
    @milestone = @list.tasks.first
    @s = %w[_ s1 s2 s3 s4 s5].map { |id| @list.sprints[id] }
  end

  test "S1 points" do
    assert_equal 1.0, @s[1].points
  end

  test "S2 points" do
    assert_equal 3.0, @s[2].points
  end

  test "S3 points" do
    assert_equal 0.0, @s[3].points
  end

  test "S4 points" do
    assert_equal 2.5, @s[4].points
  end

  test "S5 points" do
    assert_equal 1.0, @s[5].points
  end
end
