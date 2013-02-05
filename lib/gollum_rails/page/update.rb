module GollumRails
  # Public: some commonly used builtin GollumRails::Page extensions
  module PageActions
    # Public: update actions
    class Update < GollumRails::PageHelper
      call_by 'update'
      class << self
        # Public: validates if page exists
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
          page, name, format, content, commit = args

          commit = DependencyInjector.wiki.update_page(page, name, format, content, commit)

          DependencyInjector.set({:persisted => true}) if commit.is_a?(String)
          DependencyInjector.set({:persisted => false}) if not commit.is_a?(String)
        end

      end
    end
    
  end
end
