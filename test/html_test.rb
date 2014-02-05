require File.expand_path('../test_helper', __FILE__)

TESTS = %w[hello.yml multi_sprints.yml sprint_points.yml sprints.yml]

TESTS.each do |yml_file|
  describe yml_file do
    before do
      @list = TPS::TaskList.new :yaml => f(yml_file)
    end

    it "HTML" do
      html = @list.to_html
      assert html.include?("span")
      assert html.include?("body")
    end
  end
end
