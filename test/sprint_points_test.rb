require File.expand_path('../test_helper', __FILE__)

describe "Sprint points" do
  before do
    @list = TPS::TaskList.new :yaml => f('sprint_points.yml')
    @milestone = @list.tasks.first
    @s = %w[_ s1 s2 s3 s4 s5].map { |id| @list.sprints[id] }
  end

  it "S1 points" do
    assert_equal 1.0, @s[1].points
  end

  it "S2 points" do
    assert_equal 3.0, @s[2].points
  end

  it "S3 points" do
    assert_equal 0.0, @s[3].points
  end

  it "S4 points" do
    assert_equal 2.5, @s[4].points
  end

  it "S5 points" do
    assert_equal 1.0, @s[5].points
  end
end
