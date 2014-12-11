require File.expand_path('../test_helper', __FILE__)

describe "Taskpaper" do
  it "parseable" do
    data = File.read('tasks.taskpaper')
    root = TPS::TaskPaper.parse(data)
  end

  describe "basic doc" do
    before do
      @source = "Version 1:\n\t- Log in @done"
      @node = TPS::TaskPaper.parse(@source)
    end

    it "exports back to its original state" do
      assert_equal @node.to_s.strip, @source
    end
  end

  describe "2 spaces as tabs" do
    before do
      @source = "Version 1:\n  - Log in\n    - Sign up"
      @node = TPS::TaskPaper.parse(@source)
    end

    it "should work" do
      assert_equal @node.to_s.strip, @source.gsub('  ', "\t")
    end
  end

  describe "single lines" do
    it "parses a basic task" do
      @node = TPS::TaskPaper.parse("- hello").children[0]
      assert_equal @node.text, "hello"
      assert_equal @node.task?, true
      assert_equal @node.level, 1
      assert_equal @node.to_line_s, "- hello"
    end

    it "parses a task with tags" do
      @node = TPS::TaskPaper.parse("- hello @done").children[0]
      assert_equal @node.text, "hello"
      assert_equal @node.tags, ["@done"]
      assert_equal @node.task?, true
      assert_equal @node.level, 1
      assert_equal @node.to_line_s, "- hello @done"
    end

    it "parses a note" do
      @node = TPS::TaskPaper.parse("hello").children[0]
      assert_equal @node.text, "hello"
      assert_equal @node.note?, true
      assert_equal @node.level, 1
      assert_equal @node.to_line_s, "hello"
    end

    it "parses a note with fake tags" do
      @node = TPS::TaskPaper.parse("hello @done").children[0]
      assert_equal @node.text, "hello @done"
      assert_equal @node.note?, true
      assert_equal @node.level, 1
      assert_equal @node.to_line_s, "hello @done"
    end

    it "parses a task with multiple tags" do
      @node = TPS::TaskPaper.parse("- hello @ok @done").children[0]
      assert_equal @node.text, "hello"
      assert_equal @node.tags, ["@ok", "@done"]
      assert_equal @node.task?, true
      assert_equal @node.level, 1
      assert_equal @node.to_line_s, "- hello @ok @done"
    end

    it "parses a basic project" do
      @node = TPS::TaskPaper.parse("hello:").children[0]
      assert_equal @node.text, "hello"
      assert_equal @node.project?, true
      assert_equal @node.level, 1
    end

    it "parses a project with tags" do
      @node = TPS::TaskPaper.parse("hello: @done").children[0]
      assert_equal @node.text, "hello"
      assert_equal @node.tags, ["@done"]
      assert_equal @node.project?, true
      assert_equal @node.level, 1
    end
  end

  describe "TaskPaperShim" do
    before do
      @hash = TPS::TaskPaperShim.load('tasks.taskpaper')
    end

    it "should work" do
      expected = {"Sprints"=>{"s1"=>"Sprint 1 (November)", "s2"=>"Sprint 2 (Jan)", "s3"=>"Sprint 3 (December)"}, "Version 1"=>{"User signup"=>{"_"=>["s1"], "Register for an account"=>nil, "Log in"=>["done"], "Forget password"=>nil}, "Manage users"=>{"_"=>["in progress", "s1"], "Create users"=>["in progress", "s3"], "Delete users"=>nil, "User profile page"=>nil}, "Blog"=>{"Creating new posts"=>["done"], "Comments"=>["done"], "Moderating comments"=>nil}}}
      assert_equal expected, @hash
    end
  end
end
