require 'spec_helper'

describe GollumRails::Adapters::Gollum::Connector do
  before(:each) do
    @class = GollumRails::Adapters::Gollum::Connector 
  end

  it "should test the Wiki path connector" do
    @class.wiki_path.should be_a String
  end
  it "should test the Wiki options connector" do
    @class.wiki_options.should be_a Hash
  end  
  it "should test the Wiki options content" do
    @class.wiki_options.should == {}
  end  
  it "should test the Page class connector" do
    @class.page_class.should == GollumRails::Adapters::Gollum::Page
  end
    
end
