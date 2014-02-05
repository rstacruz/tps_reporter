require File.expand_path('../test_helper', __FILE__)

describe "Settings" do
  before do
    @hash = TPS::TaskPaperShim.parse("Trello URL: http://xyz\nVersion 1:\n\t- Hello")
  end

  it "use setting" do
    assert_equal "http://xyz", @hash["Trello URL"]
  end
end
