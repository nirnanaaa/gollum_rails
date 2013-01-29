require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Backend" do
  include Rack::Test::Methods
  setup do
  end
  test "#gets the load of the modules" do
   assert_instance_of Class, GollumRails::Wiki
   assert_instance_of Gollum::Wiki, GollumRails::Wiki.new(PATH)
   assert_instance_of Class, GollumRails::Page
   assert_instance_of GollumRails::Page, GollumRails::Page.new
   assert_instance_of Class, GollumRails::Engine
   assert_instance_of Class, GollumRails::Versions
   assert_instance_of Class, GollumRails::File
   assert_instance_of Class, ::Hash
  end
  test "#rails" do
    require  'rails'

  end
end
