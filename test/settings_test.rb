require File.expand_path('../test_helper', __FILE__)

class SettingsTest < UnitTest
  setup do
    @hash = TPS::TaskPaperShim.parse("Trello URL: http://xyz\nVersion 1:\n\t- Hello")
  end

  test "use setting" do
    assert_equal "http://xyz", @hash["Trello URL"]
  end
end
