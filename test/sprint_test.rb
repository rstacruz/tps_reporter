require File.expand_path('../test_helper', __FILE__)

describe "Sprint" do
  before do
    @list = TPS::TaskList.new :yaml => f('sprints.yml')
    @milestone = @list.tasks.first
    @s1 = @list.sprints['s1']
    @s2 = @list.sprints['s2']
  end

  it "Sprints" do
    assert_equal 2, @list.sprints.size
    assert_equal 'Sprint one', @s1.name
    assert_equal 'Sprint two', @s2.name
  end

  it "Sprint model attributes" do
    sprint = @list.sprints['s1']
    assert_equal 'Sprint one', sprint.name
    assert_equal @list, sprint.list
  end

  it "Tasks should be assigned to sprints" do
    assert @list['Version 1']['Account']['Login'].sprints.include?(@s1)
  end

  it "Task#contains_sprint?" do
    assert @list.contains_sprint?(@s1)
    assert @list.contains_sprint?(@s2)
  end

  it "Task#contains_sprint? part 2" do
    task = @list['Version 1']['Account']['Login']
    assert task.contains_sprint?(@s1)
    assert ! task.contains_sprint?(@s2)
  end

  it "Task#filter_by_sprint" do
    list = @list.filter_by_sprint(@s1)
    assert ! list['Version 1']['Account']['Login'].nil?
    assert list['Version 1']['Account']['Signup'].nil?
  end

  it "Sub-tasks of a sprint task" do
    list = @list.filter_by_sprint(@s1)
    task = list['Version 1']['Comments']['Creating']
    assert ! task.nil?
  end

  it "Sprint#index" do
    assert_equal 0, @list.sprints['s1'].index
    assert_equal 1, @list.sprints['s2'].index
  end

  it "Sprint#points" do
    assert_equal 5, @s1.points
  end

  it "Sprint#points_done" do
    assert_equal 3, @s1.points_done
  end
end
