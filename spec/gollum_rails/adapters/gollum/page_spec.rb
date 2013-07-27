require 'spec_helper'
describe GollumRails::Adapters::Gollum::Page do
  before(:each) do
    @commit = {
      :message => 'page action',
      :name => 'The Mosny',
      :email => 'mosny@zyg.li'
    }
  end
  describe "Connector stuff" do
    it "should have updated the page_class on initialize" do
      adapter = GollumRails::Adapters::Gollum::Page.new
      GollumRails::Adapters::Gollum::Connector.page_class.should == GollumRails::Adapters::Gollum::Page
    end
    
  end
end
