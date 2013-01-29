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
  test "#basic block assert" do
    assert_instance_of Gollum::Page, GollumRails::Page.find(@name)
    assert_equal "The page was not found", Gollum::Page.find(['static'])
    found = Gollum::Page.find do
      
    end
    puts found
  end
end
