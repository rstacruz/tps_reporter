require File.expand_path('../test_helper', __FILE__)

class HtmlTest < UnitTest
  TESTS = %w[hello.yml multi_sprints.yml sprint_points.yml sprints.yml]

  TESTS.each do |yml_file|
    context yml_file do
      setup do
        @list = TPS::TaskList.new :yaml => f(yml_file)
      end

      test "HTML" do
        html = @list.to_html
        assert html.include?("span")
        assert html.include?("body")
      end
    end
  end
end
