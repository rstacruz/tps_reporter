require File.expand_path('../test_helper', __FILE__)

class SprintTest < UnitTest
  setup do
    @list = TPS::TaskList.new yaml: f('sprints.yml')
    @milestone = @list.tasks.first
    @s1 = @list.sprints['s1']
    @s2 = @list.sprints['s2']
  end

  test "Sprints" do
    assert @list.sprints.size == 2
    assert @s1.name == 'Sprint one'
    assert @s2.name == 'Sprint two'
  end

  test "Sprint model attributes" do
    sprint = @list.sprints['s1']
    assert sprint.name == 'Sprint one'
    assert sprint.list == @list
  end

  test "Tasks should be assigned to sprints" do
    assert @list['Version 1']['Account']['Login'].sprint == @s1
  end

  test "Task#contains_sprint?" do
    assert @list.contains_sprint?(@s1)
    assert @list.contains_sprint?(@s2)
  end

  test "Task#contains_sprint? part 2" do
    task = @list['Version 1']['Account']['Login']
    assert task.contains_sprint?(@s1)
    assert ! task.contains_sprint?(@s2)
  end

  test "Task#filter_by_sprint" do
    list = @list.filter_by_sprint(@s1)
    assert ! list['Version 1']['Account']['Login'].nil?
    assert list['Version 1']['Account']['Signup'].nil?
  end

  test "Sub-tasks of a sprint task" do
    list = @list.filter_by_sprint(@s1)
    task = list['Version 1']['Comments']['Creating']
    assert ! task.nil?
  end
end

 
