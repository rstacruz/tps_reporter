require File.expand_path('../test_helper', __FILE__)

describe "URLs" do
  before do
    @list = TPS::TaskList.new data: [
      "Hello http://google.com"
    ]

    @task = @list.tasks[0]
  end

  it "use setting" do
    assert_equal "Hello", @task.name
    assert_equal "http://google.com", @task.url
  end
end
