# Setup testing
require 'spec_helper'
describe GollumRails::Setup do
  it "should setup the application" do
    GollumRails::Setup.build do |setup|

      # => The repository path to the 
      #
      #
      setup.repository = '.'      

      #setup.wiki.use = :default
      setup.startup=(true).should be_true

      setup.repository = nil
      expect{setup.startup=true}.to raise_error GollumRails::GollumInternalError
    end


  end
  class Bla < GollumRails::Page
  end
  it "should work" do

        committer = {
          :name => "Flo",
          :message => "no",
          :email => "mosny@zyg.li"
        }

    bla = Bla.new :name => "Default page", :commit => committer, :content => "#title \n ##body", :format => :markdown
    bla.save.should be_instance_of Gollum::Page
    @found = Bla.find("Default page")
  end

end
