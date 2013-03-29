require 'spec_helper'
describe GollumRails::Adapters::Gollum::Page do
  before(:each) do
    @commit = {
      :message => 'page action',
      :name => 'The Mosny',
      :email => 'mosny@zyg.li'
    }

    @location = "#{File.dirname(__FILE__)}/../../../utils/wiki.git"
    @repo = Grit::Repo.init_bare @location
    @wiki = GollumRails::Adapters::Gollum::Wiki.new @repo
    @page = GollumRails::Adapters::Gollum::Page.new 
  end
  it "should initialize the correct wiki" do
    location = "#{File.dirname(__FILE__)}/../../../utils/wiki.git"
    repo = Grit::Repo.init_bare location
    wiki = GollumRails::Adapters::Gollum::Wiki.new repo
    page = GollumRails::Adapters::Gollum::Page.new 
    page.wiki.should be_instance_of Gollum::Wiki
  end
  it "should create a new page" do
    location = "#{File.dirname(__FILE__)}/../../../utils/wiki.git"
    repo = Grit::Repo.init_bare location
    wiki = GollumRails::Adapters::Gollum::Wiki.new repo
    page = GollumRails::Adapters::Gollum::Page.new 
    page.new_page("testpage", "content",:markdown, @commit ).should be_instance_of Gollum::Page
    page.delete_page(@commit)
  end

  it "should delete an existing page" do
    page = @page.new_page 'testpage', 'content', :markdown, @commit
    @page.delete_page(@commit,page).should be_instance_of String
    
    @page.new_page 'testpage', 'content', :markdown, @commit
    @page.delete_page(@commit).should be_instance_of String
  end
  it "should update an existing page" do 
    @page.new_page 'testpage', 'content', :markdown, @commit
    page = {}
    page[:name] = 'test'
    page[:format] = :markdown
    page[:content] = "content"
    @page.update_page(page, @commit)

    page = []
    expect{@page.update_page(page, @commit)}.to raise_error GollumRails::Adapters::Gollum::Error

    page = {}
    page[:content] = "test"
    @page.update_page(page, @commit).raw_data.should == page[:content]

    page = {}
    page[:name] = "test"
    @page.update_page(page, @commit).name.should == page[:name]

    page = {}
    page[:format] = :wiki
    @page.update_page(page, @commit).format.should == :mediawiki



    @page.delete_page(@commit)
  end
  it "should find a page" do
    @page.new_page 'content_page', 'content', :markdown, @commit

    @page.find_page("content_page")
    @page.delete_page(@commit)
  end
  it "should test the commit methods" do
    @page.new_page 'content_page', 'content', :markdown, @commit
    @page.page_last_edited_date.should be_instance_of Time
    @page.page_created.should be_instance_of Time
    @page.page_last_commit.should be_instance_of Grit::Commit
    @page.page_commit(@page.page.versions.first.id).should be_instance_of Grit::Commit
    @page.page_commit_date(@page.page.versions.first.id).should be_instance_of Time
    @page.delete_page(@commit)
  end
  it "should test the error throwing" do
    expect{@page.page_last_commit}.to raise_error GollumRails::Adapters::Gollum::Error
    expect{@page.page_first_commit}.to raise_error GollumRails::Adapters::Gollum::Error
    expect{@page.page_last_edited_date}.to raise_error GollumRails::Adapters::Gollum::Error
    expect{@page.page_created}.to raise_error GollumRails::Adapters::Gollum::Error
    expect{@page.page_commit(1)}.to raise_error GollumRails::Adapters::Gollum::Error
    expect{@page.page_commit_date(1)}.to raise_error GollumRails::Adapters::Gollum::Error
  end
end
