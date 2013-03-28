require 'spec_helper'
require 'grit'

describe GollumRails::Adapters::Gollum::Wiki do
  before(:each) do
    location = "#{File.dirname(__FILE__)}/../../../utils/wiki"
    puts location
    @repo = Grit::Repo.init_bare location
    @wiki = GollumRails::Adapters::Gollum::Wiki.new(location)
  end
  it "should initialize a new wiki instance" do
    
  end
end
