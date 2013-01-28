require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Versions" do
  include Rack::Test::Methods
  class Page < GollumRails::Page

  end
  setup do

    attributes = {
      :name => 'static',
      :content => 'content',
      :format => :markdown,
      :commit => COMMIT
    }
    page = Page.new attributes
    page.save
    
    finder = Page.new
    finder.find("static")
    
    100.times do  |rounds|
      finder.update "lazy shit#{rounds}", COMMIT
    end
    
    @versions = finder.versions
  end
  teardown do
    page = Page.new
    page.find("static")
    page.delete!(COMMIT)
  end
  ##############
  #############
  ############
  # VERSIONS #
  ###########
  ##########
  #########
  ########
  #######
  ######
  #####
  ####
  ###
  ##
  #
  
  # summary
  test "#versions reader" do
    assert_instance_of Array, @versions.versions
    @versions.versions.each_with_index do |version|
      assert_instance_of Grit::Commit, version
      assert_instance_of String, version.id
      assert_instance_of Time, version.authored_date
    end
  end
  test "#all alternative to .versions" do
    assert_instance_of Array, @versions.all
    @versions.all.each_with_index do |version|
      assert_instance_of Grit::Commit, version
      assert_instance_of String, version.id
      assert_instance_of Time, version.authored_date
    end
  end
  #/summary
  
  test "#newest selection" do
    assert_instance_of Grit::Commit, @versions.latest
    assert_instance_of String, @versions.latest.id
    assert_instance_of Time, @versions.latest.authored_date
  end
  
  test "#oldest selection" do
    assert_instance_of Grit::Commit, @versions.oldest
    assert_instance_of String, @versions.oldest.id
    assert_instance_of Time, @versions.oldest.authored_date
  end
  
  test "#find specific commit" do
    assert_instance_of Grit::Commit, @versions.find(@versions.oldest.id)
  end
end
