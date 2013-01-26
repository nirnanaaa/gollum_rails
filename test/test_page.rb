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
  test "#save" do
    name =  Time.now.to_s
    @page.name = name
    
    #first run should pass
    assert_equal true, @page.save
    
    #page already exist
    assert_equal false, @page.save
  end
  
  test "#get error message" do
    @page.name = "static"
    @page.save
    assert_instance_of Gollum::DuplicatePageError, @page.get_error_message
  end
  test "#find page" do
    
    found = @page.find("static")
    assert_instance_of Gollum::Page, found
    assert_equal 'content', found.raw_data
    assert_equal :markdown, found.format
    assert_equal '<p>content</p>', found.formatted_data
    assert_equal nil, @page.get_error_message
    
  end
  test "#nil provided" do
    found_not = @page.find(nil) #same as @page.find
    assert_equal nil, found_not
  end
  test "#page not found" do
    found_not = @page.find("i am not existant or am i")
    assert_equal nil, found_not
    assert_equal "The given page was not found" ,@page.get_error_message
  end
  test "#page update" do
    origin = @page.find("static")
    assert_instance_of String, @page.update("content", @commit)
  end
  #test "#method_missing" do
  #  found = @page.find_by_id
  #  assert_instance_of Gollum::Page, found
  #end
  test "#save as differ formats" do
    
  end
end
