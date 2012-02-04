require File.expand_path('../test_helper', __FILE__)

class MyTest < UnitTest
  setup do
    @list = TPS::TaskList.new yaml: f('hello.yml')
    @milestone = @list.tasks.first
  end

  test "Has tasks" do
    assert @list.tasks?
    assert @list.tasks.size == 1
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

  test "HTML works" do
    assert @list.to_html
  end
end
