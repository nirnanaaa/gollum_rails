require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Backend" do
  include Rack::Test::Methods
  setup do
    commit = {
      :message => "test creation of page",
      :name => 'Florian Kasper',
      :email => 'nirnanaaa@khnetworks.com'
    }
    attributes = {
      name: 'TestPage',
      content: 'content',
      format: :markdown,
      commit: commit
    }
    @page = Gollum::Rails::Page.new(attributes)
  end
  test "#tests the creation of the page" do
    assert_equal false, @page.persisted?
  end
  test "#gets the git repositorys" do
   # assert
  end
  test "#is the wiki an instance of gollum?" do
    assert_equal true, @page.wikiLoaded?
    assert_instance_of Gollum::Wiki, @page.wiki.wiki
    assert_instance_of Gollum::Rails::Wiki, @page.wiki
  end
end
