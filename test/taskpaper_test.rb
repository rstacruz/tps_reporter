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

  describe "spaces as tabs" do
    before do
      @source = "Version 1:\n  - Log in"
      @node = TPS::TaskPaper.parse(@source)
    end

    it "should work" do
      assert_equal @node.to_s.strip, @source.gsub('  ', "\t")
    end
  end

  describe "shim" do
    before do
      @hash = TPS::TaskPaperShim.load('tasks.taskpaper')
    end

    it "should work" do
      expected = {"Sprints"=>{"s1"=>"Sprint 1 (November)", "s2"=>"Sprint 2 (Jan)", "s3"=>"Sprint 3 (December)"}, "Version 1"=>{"User signup"=>{"_"=>["s1"], "Register for an account"=>nil, "Log in"=>["done"], "Forget password"=>nil}, "Manage users"=>{"_"=>["in progress", "s1"], "Create users"=>["in progress", "s3"], "Delete users"=>nil, "User profile page"=>nil}, "Blog"=>{"Creating new posts"=>["done"], "Comments"=>["done"], "Moderating comments"=>nil}}}
      assert_equal expected, @hash
    end
  end
end
