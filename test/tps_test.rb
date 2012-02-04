require File.expand_path('../test_helper', __FILE__)

class MyTest < UnitTest
  setup do
    @list = TPS::TaskList.new yaml: f('hello.yml')
    @milestone = @list.tasks.first
  end

  test "Has tasks" do
    assert @list.tasks?
    assert @list.tasks.size == 2
    assert @list.tasks.first.tasks.size >= 2
  end

  test "Explicit percent" do
    task = @milestone.tasks[0]
    assert task.in_progress?
    assert task.status == :in_progress
    assert task.percent == 0.25
  end

  test "Overriding percent" do
    task = @milestone.tasks[2]
    assert task.name == "Overridden percent"
    assert task.in_progress?
    assert task.status == :in_progress
    assert task.percent == 0.5
  end

  test "Points" do
    task = @milestone.tasks[1]
    assert task.points == 2.0
  end

  test "Explicit points" do
    task = @milestone.tasks[3]
    assert task.points == 15
    assert task.percent == 0.75
    assert task.points_done == 11.25
  end

  test "Compound points" do
    task = @milestone.tasks[4]
    assert task.points == 6
    assert task.percent == 0.50
  end

  test "Point rescaling" do
    task = @milestone.tasks[5]
    assert task.points == 8
    assert task.points_done == 4.0
    assert task.percent == 0.5
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

  test "HTML works" do
    assert @list.to_html
  end
end
