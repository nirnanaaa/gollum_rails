require 'spec_helper'

describe GollumRails::Page do
  before(:each) do
    @commit = {
      :name => "flo",
      :message => "commit",
      :email => "mosny@zyg.li"
    }
    @call = {
      :name => "Goole", 
      :content => "content data", 
      :commit => @commit, 
      :format => :markdown
    }
  end

  class RailsModel < GollumRails::Page

    register_validations_for :name,
                             :format

    validate do |validator|
      validator.test(:name, "type=String")
      validator.test(:format, "type=Object")
    end
  end
  it "should test the creation of a page" do
    rr = RailsModel.new(@call)
    rr.save.should be_instance_of Gollum::Page
    rr.save!.should be_instance_of Gollum::Page
    RailsModel.create(@call)
  end
  
  it "should test the update of a page" do
    rr = RailsModel.new @call
    cc = rr.save.should be_instance_of Gollum::Page
    rr.update_attributes({:name => "google", :format => :wiki}).should be_instance_of Gollum::Page
  end

  it "should test the deletion of a page" do
    rr = RailsModel.new @call
    cc = rr.save.should be_instance_of Gollum::Page
    rr.delete.should be_instance_of String
  end

  it "should test the finding of a page" do
    RailsModel.find('google').should be_instance_of Gollum::Page

    #invalid input
    RailsModel.find('<script type="text/javascript">alert(123);</script>').should be_nil
  end

  it "should test the supported formats" do
    RailsModel.format_supported?('ascii').should be_true
    RailsModel.format_supported?('markdown').should be_true
    RailsModel.format_supported?('github-markdown').should be_true
    RailsModel.format_supported?('rdoc').should be_true
    RailsModel.format_supported?('org').should be_true
    RailsModel.format_supported?('pod').should be_true
  end

end
