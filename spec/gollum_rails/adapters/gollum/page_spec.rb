require 'spec_helper'
describe GollumRails::Adapters::Gollum::Page do
  it "should initialize the correct wiki" do
    location = "#{File.dirname(__FILE__)}/../../../utils/wiki.git"
    repo = Grit::Repo.init_bare location
    wiki = GollumRails::Adapters::Gollum::Wiki.new repo
    page = GollumRails::Adapters::Gollum::Page.new 
    page.wiki.should be_instance_of Gollum::Wiki

  end
end
