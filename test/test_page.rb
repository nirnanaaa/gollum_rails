require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Page Test" do
  include Rack::Test::Methods
  setup do
    @commit = {
      :message => "test creation of page",
      :name => 'Florian Kasper',
      :email => 'nirnanaaa@khnetworks.com'
    }
    attributes = {
      name: 'TestPage',
      content: 'content',
      format: :markdown,
      commit: @commit
    }
    @page = Gollum::Rails::Page.new(attributes)
  end
  test "#tests the creation of the page" do
    assert_equal false, @page.persisted?
  end
  test "#tests the valid?`function" do
    assert_equal true, @page.valid?
    @page.name = nil
    assert_equal false, @page.valid?
    @page.name = 'TestPage'
    @page.format = nil
    assert_equal false, @page.valid?
    @page.format = :markdown
    @page.commit = false
    assert_equal false, @page.valid?
    @page.commit = @commit
  end
  test "#is the wiki an instance of gollum?" do
    assert_equal true, @page.wikiLoaded?
    assert_instance_of Gollum::Wiki, @page.wiki.wiki
    assert_instance_of Gollum::Rails::Wiki, @page.wiki
  end
end
