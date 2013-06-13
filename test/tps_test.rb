require File.expand_path('../test_helper', __FILE__)

class MyTest < UnitTest
  setup do
    @list = TPS::TaskList.new :yaml => f('hello.yml')
    @milestone = @list.tasks.first
  end

  test "Has tasks" do
    assert @list.tasks?
    assert_equal 2, @list.tasks.size
    assert @list.tasks.first.tasks.size >= 2
  end

  test "Explicit percent" do
    task = @milestone.tasks[0]
    assert task.in_progress?
    assert_equal :in_progress, task.status
    assert_equal 0.25, task.percent
  end

  test "Overriding percent" do
    task = @milestone.tasks[2]
    assert_equal "Overridden percent", task.name
    assert task.in_progress?
    assert_equal :in_progress, task.status
    assert_equal 0.5, task.percent
  end

  test "Points" do
    task = @milestone.tasks[1]
    assert_equal 2.0, task.points
  end

  test "Explicit points" do
    task = @milestone.tasks[3]
    assert_equal 15, task.points
    assert_equal 0.75, task.percent
    assert_equal 11.25, task.points_done
  end

  test "Compound points" do
    task = @milestone.tasks[4]
    assert_equal 6, task.points
    assert_equal 0.50, task.percent
  end

  test "Point rescaling" do
    task = @milestone.tasks[5]
    assert_equal 8, task.points
    assert_equal 4.0, task.points_done
    assert_equal 0.5, task.percent
  end

  test "In progress" do
    task = @milestone.tasks[6]
    assert_equal 2, task.tasks.size
    assert task.tasks[1].in_progress?
    assert_equal 0.5, task.tasks[1].percent
    assert_equal 0.5, task.tasks[1].points_done
    assert_equal 0.25, task.percent
  end

  test "Progress override" do
    task = @milestone.tasks[7]
    assert_equal 0.2, task.percent
    assert_equal 0.4, task.points_done
  end

  test "Milestone" do
    assert @milestone.milestone?
  end

  test "Not milestone" do
    @milestone.tasks.each do |t|
      assert ! t.milestone?
    end
  end

  test "HTML works" do
    assert @list.to_html
  end

  test "Lookup" do
    assert_equal @milestone, @list['Milestone 1']
  end

  context "Task#find" do
    test "self name" do
    end

    test "descendant" do
      assert_equal @list['Milestone 1'], @list.find('Milestone 1')
    end

    test "Grand-child" do
      assert_equal @list.tasks[0].tasks[1], @list.find('User login')
    end

    test "non-existent" do
      assert_equal nil, @list.find("X")
    end
  end

  test "Task#breadcrumbs" do
    crumbs = @list['Milestone 1']['User login']['Signup'].breadcrumbs
    expected = [
      @list['Milestone 1'],
      @list['Milestone 1']['User login'],
      @list['Milestone 1']['User login']['Signup']
    ]
    assert_equal expected, crumbs
  end

  test "Task#breadcrumbs(false)" do
    crumbs = @list['Milestone 1']['User login']['Signup'].breadcrumbs(false)
    expected = [
      @list['Milestone 1'],
      @list['Milestone 1']['User login']
    ]
    assert_equal expected, crumbs
  end
end
