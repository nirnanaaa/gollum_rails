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
            def initialized_first
              super
            end

            def single_run(*argv)

            end

            def mass_assignment(&block)

            end
          end

        end
      end
    end

    assert_equal false, GollumRails::DependencyInjector.error
  end
  test "#" do

  end

end
