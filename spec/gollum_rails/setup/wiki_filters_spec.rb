require 'spec_helper'

describe "Wiki filters spec"do
  it "has filter test after code" do
    GollumRails::Setup.filters << [:FilterTest, {:after => :Code}]
    expect(GollumRails::Page.wiki.filter_chain).to include(:FilterTest)
  end
  it "processes code normally" do
    GollumRails::Setup.filters << [:FilterTest, {:after => :Code}]
    expect(build(:gollum_page_spec).preview).to match 'append'

  end
  after(:each) do
    GollumRails::Setup.filters = []
  end
end
