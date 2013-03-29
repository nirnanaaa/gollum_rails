require 'spec_helper'
describe GollumRails::Adapters::Gollum::Page do
  before(:each) do
    @commit = {
      :message => 'page action',
      :name => 'The Mosny',
      :email => 'mosny@zyg.li'
    }
  end
  it "should initialize the correct wiki" do
    location = "#{File.dirname(__FILE__)}/../../../utils/wiki.git"
    repo = Grit::Repo.init_bare location
    wiki = GollumRails::Adapters::Gollum::Wiki.new repo
    page = GollumRails::Adapters::Gollum::Page.new 
    #page.wiki.should be_instance_of Gollum::Wiki
  end
  it "should create a new page" do
    location = "#{File.dirname(__FILE__)}/../../../utils/wiki.git"
    repo = Grit::Repo.init_bare location
    wiki = GollumRails::Adapters::Gollum::Wiki.new repo
    page = GollumRails::Adapters::Gollum::Page.new 
    page.new_page("testpage", "content",:markdown, @commit )
    page.delete_page(nil, @commit)
  end
end
