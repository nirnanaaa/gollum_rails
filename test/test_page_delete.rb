require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Page_Singleton" do
  include Rack::Test::Methods
  setup do
    # test creation
    @name = 'static'
    @commit = {
      :message => "test creation of page",
      :name => 'Florian Kasper',
      :email => 'nirnanaaa@khnetworks.com'
    }
    attributes = {
      :name => @name,
      :content => 'content',
      :format => :markdown,
      :commit => @commit
    }
    @page = GollumRails::Page.new(attributes)
    @page.save
    
  end
  teardown do

    page = GollumRails::Page.new
    @page.find(@name)
    @page.delete @commit

    #GollumRails::Page.find('static') #newest version

  end
  test "#basic deletion" do
    found = GollumRails::Page.find(@name)
    assert_instance_of Gollum::Page, found
    fs = false
    ::Dir.glob(::File.expand_path(::File.dirname(__FILE__)) + '/wiki/static.md') do |file|
      fs = File.exists? file
    end
    assert_equal true, fs
    fs = false
    assert_instance_of String, GollumRails::Page.delete(found, @commit)
    assert_instance_of String, GollumRails::Page.delete(@commit)
    
    ::Dir.glob(::File.expand_path(::File.dirname(__FILE__)) + '/wiki/static.md') do |file|
      fs = File.exists? file
    end
    assert_equal false, fs
    #assert_equal "The page was not found", Gollum::Page.find(['static'])
  end
  test "#" do
    
  end
  
end
