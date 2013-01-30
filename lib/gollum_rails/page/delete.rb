module GollumRails
  module PageActions
    class Delete < GollumRails::PageHelper
      # Public: Page.<call_by> . The method call will be generated with this information
      call_by 'delete'
      call_by 'delete!'


      class << self
        # Public: runs the initializer from superclass ( super clears the error buffer )
        #
        # Returns nothing
        def initialized_first
          raise GollumRails::PageActions::NoPageLoadedError, "is nil or empty" if
          not DependencyInjector.page

          super
        end

        # Public: performs upper methods in Page class
        #
        #
        # Examples
        #   Page.delete(commit)
        #   # => bff724693765c461846b68de5369a40e706194e1
        #
        #   Page.delete(<Page instance>, commit)
        #   # => bff724693765c461846b68de5369a40e706194e1
        #
        #   # you can fill with much nils/foobar as you want
        #
        #   Page.delete(<Page instance>, nil, "foobar", String.new, commit)
        #   # => bff724693765c461846b68de5369a40e706194e1
        #
        # Returns String
        def single_run(*argv)

          unless argv.length > 1
            return DependencyInjector.wiki.delete_page((DependencyInjector.page),
            (argv.last if argv.last.is_a?(Hash))) if
            DependencyInjector.page.is_a?(Gollum::Page)
          else
            return DependencyInjector.wiki.delete_page((argv.first if argv.first.is_a?(Gollum::Page)),
            (argv.last if argv.last.is_a?(Hash)))
          end
        end

        def mass_assignment(&block)

        end
      end
    end
  end
end
