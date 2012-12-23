require File.expand_path('../test_helper', __FILE__)

class SprintTest < UnitTest
  context "Basic sprints" do
    setup do
      @list = TPS::TaskList.new yaml: f('sprints.yml')
      @milestone = @list.tasks.first
      @s1 = @list.sprints['s1']
      @s2 = @list.sprints['s2']
    end

    test "Sprints" do
      assert_equal 2, @list.sprints.size
      assert_equal 'Sprint one', @s1.name
      assert_equal 'Sprint two', @s2.name
    end

    test "Sprint model attributes" do
      sprint = @list.sprints['s1']
      assert_equal 'Sprint one', sprint.name
      assert_equal @list, sprint.list
    end

    test "Tasks should be assigned to sprints" do
      assert_equal @s1, @list['Version 1']['Account']['Login'].sprint
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

    test "Sprint#index" do
      assert_equal 0, @list.sprints['s1'].index
      assert_equal 1, @list.sprints['s2'].index
    end

    test "Sprint#points" do
      assert_equal 5, @s1.points
    end

    test "Sprint#points_done" do
      assert_equal 3, @s1.points_done
    end
  end

  context "Sprint points" do
    setup do
      @list = TPS::TaskList.new yaml: f('sprint_points.yml')
      @milestone = @list.tasks.first
      @s1 = @list.sprints['s1']
      @s2 = @list.sprints['s2']
    end

    test "S1 points" do
      puts "\n", @s1.sublist.to_markdown
      assert_equal 1.0, @s1.points
    end

    test "S2 points" do
      assert_equal 3.0, @s2.points
    end
  end
end
