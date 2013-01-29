require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Backend" do
  include Rack::Test::Methods
  setup do
  end
  test "#gets the path of the wiki" do
    assert_not_nil WIKI.getPath
    assert_instance_of String, WIKI.getPath
    assert_equal PATH, WIKI.getPath

  end
  test "#gets the git repository" do
   # assert
  end
end
