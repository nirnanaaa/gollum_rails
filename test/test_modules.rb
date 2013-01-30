require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Backbone module extender" do
  include Rack::Test::Methods
  setup do

  end
  teardown do

  end
  test "#basic module extender" do
    module GollumRails
      module PageActions
        class Finder < GollumRails::PageHelper
          call_by 'finder'
          class << self
            def single_run(*argv)
              return *argv
            end
          end

        end
      end
    end
    #assert_instance_of(Array, Gollum::Page.finder)
    gollum_rails = GollumRails::Page.new
    assert_instance_of Array, GollumRails::Page.finder(1,2,3,4)
    assert_instance_of Array, gollum_rails.finder(1,2,3,4)
    
    assert_equal [1,2,3,4], gollum_rails.finder(1,2,3,4)
    assert_equal false, GollumRails::DependencyInjector.error
    
  end
  test "#" do

  end

end
