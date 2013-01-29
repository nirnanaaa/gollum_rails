module GollumRails
  module PageActions
    class Find < GollumRails::PageHelper
      call_by 'find'
      class << self
        def initialized_first

        end

        def single_run(*args)
          return "hello"
        end

        def mass_assignment(&block)

        end
      end
    end
  end
end
