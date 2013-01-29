require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Backend" do
  include Rack::Test::Methods
  setup do
  end
  test "#gets the path of the wiki" do
    assert_not_nil GollumRails::DependencyInjector.wiki_path
    assert_instance_of String, GollumRails::DependencyInjector.wiki_path
    assert_equal PATH, GollumRails::DependencyInjector.wiki_path

  end
  test "#gets the git repository" do
   # assert
  end
end
