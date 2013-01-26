require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Configuration" do
  include Rack::Test::Methods
  setup do
    @config = Gollum::Rails::Config
  end
  test "#config load" do
    assert_instance_of Hash, @config.read_config
  end
end
