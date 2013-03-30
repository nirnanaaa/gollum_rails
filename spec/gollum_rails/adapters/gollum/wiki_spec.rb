require 'spec_helper'
require 'grit'

describe GollumRails::Adapters::Gollum::Wiki do
  before(:each) do
    @location = "#{File.dirname(__FILE__)}/../../../utils/wiki.git"
    @repo = Grit::Repo.init_bare @location
    @wiki = GollumRails::Adapters::Gollum::Wiki.new @repo
  end
  it "should test initializer" do
    wiki = GollumRails::Adapters::Gollum::Wiki.new @location
    @wiki.git.should == @repo
    wiki.git.should be_instance_of(String)
    wiki.git.should == @location
  end
  it "should test the creation of a new wiki" do
    wiki = GollumRails::Adapters::Gollum::Wiki.wiki @repo
    wiki.git.should == @repo
    wiki = GollumRails::Adapters::Gollum::Wiki.wiki @location
    wiki.git.should == @location
    GollumRails::Adapters::Gollum::Connector.wiki_class.should be_instance_of(::Gollum::Wiki)
  end
  it "should test the error throwing and forwarding" do
    expect{GollumRails::Adapters::Gollum::Wiki.write_page}.to raise_error ArgumentError
  end

end
