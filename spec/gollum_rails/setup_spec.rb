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
      setup.startup.should be_true

      setup.repository = nil
      expect{setup.startup}.to raise_error GollumRails::GollumInternalError
    end


  end
end
