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
  describe "statically methods" do
    it "is a hash" do
      GollumRails::Adapters::Gollum::Page.parse_path('google/de').should be_a Hash
    end
    it "should equal" do
      path1 = GollumRails::Adapters::Gollum::Page.parse_path('google/de')
      path2 = GollumRails::Adapters::Gollum::Page.parse_path('/google/de')
      path1.should == path2
    end
    it "adds a leading slash" do
      GollumRails::Adapters::Gollum::Page.parse_path('google/de')[:path][0].should == '/'
    end
  end
end
