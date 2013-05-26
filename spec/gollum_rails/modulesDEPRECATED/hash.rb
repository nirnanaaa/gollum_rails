require 'spec_helper'

describe ::Hash do
  before(:each) do
    @hash_a = {:a => "b", :b => "c"}
    @hash_b = {a: "b", b: "c"}
  end
  it "should initialize a new hash" do
    @hash_a.should be_instance_of(Hash)
    @hash_b.should be_instance_of(Hash)
    @hash_b.should == @hash_a
    @hash_b.a.should == @hash_b[:a]
    @hash_b.b.should == @hash_b[:b]
    @hash_b.a.should == @hash_a.a
    @hash_b.b.should == @hash_a.b
  end
  it "should change the value by method missing" do

    @hash_c = {:hooh => "c", :tripple => {:d => "d"}}
    @hash_d = Hash.new
    expect{@hash_d.x}.to raise_error
    #@hash_a.d.to_s.should == "{ d: 'd', x: 'Hash.new' }"
    #@hash_a.d.should be_instance_of(Hash)
    #puts @hash_a.d
    #expect{@hash_a.hash = {d:"d"}}.to be_equal Hash['{:a=>"b", :b=>"c", "b"=>[3], :d=>"d"}']
    #puts @hash_a
    #@hash_a.a = "other"
    #puts @hash_a
    #expect{@hash_a.a = "other"}.to be_equal "other"
  end
end
