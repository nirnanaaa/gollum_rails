require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Backend" do
  include Rack::Test::Methods
  setup do
    @path = testpath(".") + '/wiki'
    @wiki = Gollum::Rails::Wiki.new(@path)
  end
  test "#gets the path of the wiki" do
    assert_not_nil @wiki.getPath
    assert_instance_of String, @wiki.getPath
    assert_equal @path, @wiki.getPath
    
  end
  test "#gets the git repository" do
   # assert
  end
end
