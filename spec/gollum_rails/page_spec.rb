require 'spec_helper'

describe GollumRails::Page do
  before(:each) do
    @commit = {
      :name => "flo",
      :message => "commit",
      :email => "mosny@zyg.li"
    }
  end
  it "should extend a rails model" do
    
    class RailsModel < GollumRails::Page

      register_validations_for :name,
                               :format

      validate do |validator|
        validator.test(:name, "type=String")
        validator.test(:format, "type=Object")
      end
    end

    rr = RailsModel.new :name => "Goole", :content => "content data", :commit => @commit, :format => :markdown
    puts rr.save.class

    #RailsModel.model?(GollumRails::Page).should be_true

  end
end
