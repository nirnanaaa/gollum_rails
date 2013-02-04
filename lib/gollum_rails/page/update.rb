module GollumRails
  # Public: some commonly used builtin GollumRails::Page extensions
  module PageActions
    # Public: update actions
    class Update < GollumRails::PageHelper
      call_by 'update'
      class << self
        # function initializer
        def initialized_first
          raise GollumRails::PageActions::NoPageLoadedError, "no page loaded! Please verify that you call find() before update()" if
          not DependencyInjector.page
        end

        # Public: function main call
        #
        # name - String of the pages' name (optional on content change)
        # commit - Hash of commit data (necessary)
        # content - pages content (updated?) (optional on rename)
        # format - String of the pages format (optional)
        # page - Gollum::Page instance (optional)
        #
        # Returns the commit string
        def single_run(*args)
          name = self.class.f_name(args[0])
          commit = args[1] if args[1].is_a? ::Hash
          content = args[2] if not args[2].empty?
          format = args[3] if not args[3].is_nil?
          page = args[4] if args[4].is_a? Gollum::Page

          if commit.nil? || content.nil?
            @error = @options.messages.commit_not_empty_and_content_not_empty
            return false
          end
          commit = DependencyInjector.wiki.update_page(@page, @name, @format, content, commit)
          if commit.is_a?(String)
            @persisted = true
            return commit
          else
            @persisted = false
            return nil
          end
        end

      end
      private
      def f_name(name)
        name || GollumRails::DependencyInjector.page.name
      end
      def f_content(content)
      end
      def f_format(format)
      end
      def f_page(page)
      end
    end
  end
end
