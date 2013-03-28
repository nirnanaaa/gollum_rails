require 'spec_helper'

describe GollumRails::Adapters::Gollum do
  before(:each) do
  end
  it "should return the right version" do
    GollumRails::Adapters::Gollum.VERSION.should == "0.0.0"

  end
end
