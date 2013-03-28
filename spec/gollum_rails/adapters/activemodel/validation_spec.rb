require 'spec_helper'
describe GollumRails::Adapters::ActiveModel::Validation do
  before(:each) do
    @model = GollumRails::Adapters::ActiveModel::Validation.new

  end
  it "should object types" do
    test = {}
    test[:boolean] = true
    test[:string] = "Stringity"
    test[:integer] = 1
    test[:hash] = {}
    test[:array] = []
    test[:object] = Object
    @model.validate do |sm|
      sm.test(test[:string], "type=String").should be_true
      sm.test(test[:array], "type=Integer").should be_false
      sm.test(test[:string], "type=Object").should be_true
      sm.test(test[:hash], "type=String").should be_false
      sm.test(test[:integer], "type=Integer").should be_true
      sm.test(test[:integer], "type=Object").should be_true
      sm.test(test[:boolean], "type=Object").should be_true
      sm.test(test[:boolean], "type=Boolean").should be_true
      sm.test(test[:boolean], "type=TrueClass").should be_true
      sm.test(test[:boolean], "type=FalseClass").should be_false
      sm.test(test[:object], "type=Object").should be_true
      sm.test(test[:array], "type=Array").should be_true
      sm.test(test[:array], "type=Boolean").should be_false
      sm.test(test, "type=Hash").should be_true
    end
  end
  it "should test module Boolean" do
    @model.test(true, "type=Boolean").should be_true    
    @model.test(false, "type=Boolean").should be_true
    @model.test(true, "type=TrueClass").should be_true    
    @model.test(false, "type=FalseClass").should be_true
  end
  
  it "should test the maxlen" do
    @model.validate do |sm|
      sm.test("stringvalue", "min=20").should be_false
      sm.test("stringvalue", "max=200").should be_true
      sm.test(1, "min=2").should be_false
      sm.test(2, "max=4").should be_true
    end
  end
  it "should test the presence validator" do
    @model.validate do |sm|
      sm.test([ ], "present=true").should be_false
      sm.test(nil, "presence=true").should be_false
      sm.test("test", "presence=true").should be_true
    end
  end
  it "tests chaining" do
    @model.validate do |sm|
      sm.test("google.de", "type=String,presence=true").should be_true
      sm.test("google.com", "type=Integer,presence=true").should be_false
      sm.test([ ], "type=Object,presence=true").should be_false
      sm.test("google.de", "type=String,min=1,max=20,presence=true").should be_true
      sm.test("google.de", "type=String,min=20,max=40").should be_false
      sm.test(1, "type=Integer,min=1,max=20").should be_true
    end
  end
  it "should test error message output" do
    preset = "google.de"
    @model.test(preset, "min=20")
    @model.error[:variable][0].should == "is too short (minimum is 20 characters)"
    
    @model.test preset, "type=Integer"
    @model.error[:type][0].should == "not a kind of given class Integer"

    @model.test preset, "max=2"
    #is too long (maximum is 2 characters)
    @model.error[:variable][0].should == "is too long (maximum is 2 characters)"

    
  end

  it "should test the performance" do
    @model.validate do |sm|
      100.times do
        expect do
          sm.test("veryshortstring", "presence=true,max=2,min=1")
        end.to take_less_than(0.1).seconds
      end
    end
  end

  it "should test the blank param" do
    @model.validate do |sm|
      #sm.test("string")
    end
  end
end
