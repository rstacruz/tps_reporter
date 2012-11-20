require File.expand_path('../test_helper', __FILE__)

class SprintTest < UnitTest
  setup do
    @list = TPS::TaskList.new yaml: f('sprints.yml')
    @milestone = @list.tasks.first
  end

  test "Sprints" do
    assert @list.sprints.size == 2
    assert @list.sprints['s1'].name == 'Sprint one'
    assert @list.sprints['s2'].name == 'Sprint two'
  end

  test "Sprint model attributes" do
    sprint = @list.sprints['s1']
    assert sprint.name == 'Sprint one'
    assert sprint.list == @list
  end

  test "Tasks should be assigned to sprints" do
    assert @list['Version 1']['Account']['Login'].sprint == @list.sprints['s1']
  end

end

 
