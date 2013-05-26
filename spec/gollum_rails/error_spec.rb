require 'spec_helper'
describe GollumRails::GollumInternalError do

  it "should display a fancy inspect" do
 	GollumRails::GollumInternalError.new("hihi").inspect.should include("{name: \"hihi\"")
  end
  it "should raise an error with custom message" do
  	expect{raise GollumRails::GollumInternalError.new("myname", "is", "i am the message")}.to raise_error
  end
end
