require File.expand_path('../test_helper', __FILE__)

describe "Bar test" do
  before do
    @list = TPS::TaskList.new :yaml => f('markers.yml')
    @milestone = @list.tasks.first

    @week = %w[w0 w1 w2 w3 w4 w5 w6].map { |id| @list.sprints[id] }
  end

  it "basic sanity check" do
    assert_equal 2, @list.find("Login").sprints.length
  end

  describe "#index_segments" do
    it "disjointed" do
      task = @list.find("Disjointed")
      bar = task.bar_formatter
      assert_equal [(1..2), (4..4)], bar.index_segments
    end

    it "continuous" do
      task = @list.find("Continuous")
      bar = task.bar_formatter
      assert_equal [(1..4)], bar.index_segments
    end

    it "disjointed with head" do
      task = @list.find("Disjointed with head")
      bar = task.bar_formatter
      assert_equal [(1..1), (3..4)], bar.index_segments
    end

    it "disjointed with two segments" do
      task = @list.find("Disjointed with two segments")
      bar = task.bar_formatter
      assert_equal [(2..3), (5..6)], bar.index_segments
    end
  end

  describe "#segments" do
    it "disjointed" do
      task = @list.find("Disjointed")
      bar = task.bar_formatter
    end
  end
end
