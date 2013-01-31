require File.expand_path(File.join(File.dirname(__FILE__), "helper"))

context "Backbone module extender" do
  include Rack::Test::Methods
  setup do

  end
  teardown do

  end

  test "#basic PAGE:: module extender" do
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
    gollum_rails = GollumRails::Page.new
    assert_instance_of Array, GollumRails::Page.finder(1,2,3,4)
    assert_instance_of Array, gollum_rails.finder(1,2,3,4)

    assert_equal [1,2,3,4], gollum_rails.finder(1,2,3,4)

    assert_equal false, GollumRails::DependencyInjector.error


  end

  test "#error cleaning / getting " do
    text = "something happened"
    GollumRails::DependencyInjector.set({:error => text})

    assert_equal text, GollumRails::DependencyInjector.error
    assert_instance_of String, GollumRails::DependencyInjector.error
    assert_equal false, GollumRails::DependencyInjector.error_old

    # clear errors
    GollumRails::PageHelper.initialized_first
    assert_instance_of FalseClass, GollumRails::DependencyInjector.error
    assert_equal false, GollumRails::DependencyInjector.error
    assert_instance_of String, GollumRails::DependencyInjector.error_old
    assert_equal text, GollumRails::DependencyInjector.error_old

  end

  test "#errors" do
    assert_raise GollumRails::CommitMustBeGivenError do
      raise GollumRails::CommitMustBeGivenError
    end
    assert_raise GollumRails::NoPageLoadedError do
      raise GollumRails::NoPageLoadedError
    end
    assert_raise GollumRails::ModuleInternalError do
      raise GollumRails::ModuleInternalError
    end
  end

end
