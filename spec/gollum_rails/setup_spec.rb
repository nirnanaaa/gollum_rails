# Setup testing
require 'spec_helper'
require 'rails'
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
  it "should test the disable behavior" do
    GollumRails::Adapters::Gollum::Connector.enabled = false

    committer = {
          :name => "Flo",
          :message => "no",
          :email => "mosny@zyg.li"
        }

    expect{Bla.new :name => "Default page", :commit => committer, :content => "#title \n ##body", :format => :markdown}.to raise_error GollumRails::GollumInternalError
  end
  it "should test the applications config" do
    GollumRails::Setup.build do |config|
      config.repository = :application

      expect{setup.startup=true}.to raise_error
    end
  end

end
