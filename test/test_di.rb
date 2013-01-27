require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Configuration" do
  include Rack::Test::Methods
  setup do
    
  end
  test "#basic block assert" do
    GollumRails::DependencyInjector.register do |r|
      
    end
  end
end
