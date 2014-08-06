# Setup testing
require 'spec_helper'
require 'rails'
describe GollumRails::Setup do
  it "should setup the application" do
    expect{
      GollumRails::Setup.build do |setup|
        setup.repository = '.'      
      end
    }.not_to raise_error
    


  end
  it "should raise an error because no repo was supplied" do
    expect{
      GollumRails::Setup.build do |setup|
        setup.repository = nil     

      end
    }.to raise_error
  end
  class Bla < GollumRails::Page
  end

  it "could not start without a rails configuration" do
    
    expect {
      GollumRails::Setup.build do |config|
        config.repository = :application

      end
    }.to raise_error GollumRails::Setup::GollumRailsSetupError
    
  end
  it "should throw an error if a pathname was supplied that does not exist" do
    expect{
      GollumRails::Setup.build do |setup|
        setup.repository = Pathname.new('/nonexistingdirectoryshouldbenonexisting') 
      end
    }.to raise_error GollumRails::Setup::GollumRailsSetupError
  end
  it "should also initialize without a block given" do
    expect{
      GollumRails::Setup.build(repository: '.')
    }.not_to raise_error
  end

  it "should not accept empty options. or set it to default" do
    expect{
      GollumRails::Setup.build(wiki_options: nil)
    }.not_to raise_error
    expect(GollumRails::Setup.wiki_options).to be_kind_of Hash
  end


end
