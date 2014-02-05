require File.expand_path('../test_helper', __FILE__)

describe "Multi sprints" do
  before do
    @list = TPS::TaskList.new :yaml => f('multi_sprints.yml')
    @milestone = @list.tasks.first

    @week = %w[_ w1 w2 w3 w4].map { |id| @list.sprints[id] }
  end

  it "Sprints" do
    sprints = @list.find('Login').sprints

    assert_equal 2, sprints.length
    assert sprints.include?(@week[1])
    assert sprints.include?(@week[2])
  end

  it "points (1)" do
    assert_equal 6, @week[1].points
  end

  it "points (2)" do
    assert_equal 2, @week[2].points
  end
end
