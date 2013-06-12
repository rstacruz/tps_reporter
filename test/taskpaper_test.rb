require File.expand_path('../test_helper', __FILE__)

class TaskpaperTest < UnitTest
  test "parseable" do
    data = File.read('tasks.taskpaper')
    root = TPS::TaskPaper.parse(data)
  end

  describe "basic doc" do
    setup do
      @source = "Version 1:\n\t- Log in @done"
      @node = TPS::TaskPaper.parse(@source)
    end

    test "should work" do
      assert_equal @node.to_s.strip, @source
    end
  end

  describe "shim" do
    setup do
      @hash = TPS::TaskPaperShim.load('tasks.taskpaper')
    end

    test "should work" do
      puts YAML.dump(@hash)
    end
  end
end
