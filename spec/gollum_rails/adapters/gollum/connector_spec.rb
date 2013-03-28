require 'spec_helper'

describe GollumRails::Adapters::Gollum::Connector do
  before(:each) do
    @class = GollumRails::Adapters::Gollum::Connector 
  end

  it "should test the Wiki class connector" do
    @class.wiki_class.should == GollumRails::Adapters::Gollum::Wiki
  end
  it "should test the Page class connector" do
    @class.page_class.should == GollumRails::Adapters::Gollum::Page
  end
  it "should test the Committer class connector" do
    @class.committer_class.should == GollumRails::Adapters::Gollum::Committer
  end
    
end
