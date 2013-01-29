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
      :name => 'TestPage',
      :content => 'content',
      :format => :markdown,
      :commit => @commit
    }
    @page = GollumRails::Page.new(attributes)

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
    wiki = GollumRails::DependencyInjector.wiki
    assert_equal true, @page.wiki_loaded?(wiki)
    assert_instance_of Gollum::Wiki, wiki
  end
  test "#save" do
    name =  Time.now.to_s
    @page.name = name

    #first run should pass
    assert_instance_of String, @page.save

    #page already exist
    assert_equal false, @page.save

    f = @page.find(name)
    assert_instance_of String, @page.delete(@commit)

  end

  test "#get error message" do
    @page.name = "static"
    @page.save
    assert_instance_of Gollum::DuplicatePageError, @page.get_error_message
  end
  test "#find page" do
    @page.name = "static"
    @page.save

    found = @page.find("static")
    assert_instance_of Gollum::Page, found
    assert_equal 'content', found.raw_data
    assert_equal :markdown, found.format
    assert_equal '<p>content</p>', found.formatted_data

  end
  test "#nil provided" do
    found_not = @page.find(nil) #same as @page.find
    assert_equal nil, found_not
  end
  test "#page not found" do
    found_not = @page.find("i am not existant or am i")
    assert_equal nil, found_not
    assert_equal "The page was not found" ,@page.get_error_message
  end
  test "#page update" do
    @page.name = "static"
    @page.save
    origin = @page.find("static")
    assert_instance_of String, @page.update("content", @commit)
  end
  #test "#method_missing" do
  #  found = @page.find_by_id
  #  assert_instance_of Gollum::Page, found
  #end

  test "#production test runs (create|update|delete)" do
    wiki = GollumRails::Wiki.new(PATH)
    page = GollumRails::Page.new
    commit = {
      :message => "production test update",
      :name => 'Florian Kasper',
      :email => 'nirnanaaa@khnetworks.com'
    }

    cnt = page.find("static")

    update = page.update("content", commit)
    assert_instance_of String, update

    commit[:message] = "test delete"
    delete = page.delete(commit)
    assert_instance_of String, delete

    commit[:message] = "test create"
    page = GollumRails::Page.new({
      :name => 'static',
      :content => 'content',
      :format => :markdown,
      :commit => commit
    })
    assert_instance_of String, page.save
  end

  ### RAILS MODEL
  class Page < GollumRails::Page
  end

  ###/RAILS MODEL

  test "#rails model test" do
    ## Controller
    commit = {
      :message => "rails test",
      :name => 'Florian Kasper',
      :email => 'nirnanaaa@khnetworks.com'
    }

    time = Time.now.to_s
    page = Page.new({
      :name => "static-#{time}",
      :content => 'content',
      :format => :markdown,
      :commit => commit
    })
    save = page.save!
    assert_instance_of String, save

    found = page.find "static-#{time}"

    assert_instance_of Gollum::Page, found

    assert_instance_of String, page.delete!(commit)

  end

  test "#attr setter" do
    page = Page.new

    page.name = "testpage"
    page.content = "content"
    page.format = :markdown

    page.commit = {
      :message => "rails test",
      :name => 'Florian Kasper',
      :email => 'nirnanaaa@khnetworks.com'
    }
    assert_equal "testpage", page.name

    #must differ in message
    assert_not_equal @commit, page.commit
    assert_equal "content", page.content
    assert_equal :markdown, page.format
    assert_instance_of Hash, page.commit
  end

  test "#formats" do
    page = Page.new

    TESTFORMATS.each do |k,f|
        commit = {
          :message => "test",
          :name => 'FlorianKasper',
          :email => 'nirnanaaa@khnetworks.com'
        }
        page.content = "foo bar" * 10000000
        page.name = "doc" + k.to_s
        page.format = k
        page.save
    end
  end
  test "#preview" do
    page = Page.new
    assert_it = File.read(File.join(File.dirname(__FILE__) + "/rendering/html", "result.html"))
    TESTFORMATS.each do |k,f|
      if !k.nil?
        preview = page.preview("testpage", File.read(File.join(File.dirname(__FILE__) + "/rendering/#{k}", "test.#{k}")), k)
        assert_equal assert_it, preview.split("\n").join("")
      end
    end
    #puts GollumRails::Page.find("static")
  end


end
