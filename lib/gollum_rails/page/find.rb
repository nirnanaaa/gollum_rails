module GollumRails
  module PageActions
    # Public: .find extension for GollumRails::Page
    class Find < GollumRails::PageHelper
      call_by 'find'
      
      class << self
        # Public: runs the initializer from superclass ( super clears the error buffer )
        #
        # Returns nothing
        def initialized_first
          #self.instance_variable_set("@wiki")
          
          super
        end

        # Public: Finds a page based on given search string
        #
        #
        # Examples
        #   found = page.find('static')
        #   # => Gollum::Page
        #
        #   found.raw_data
        #   # => some string data. Unformatted
        #
        #   found.formatted_data
        #   # => some <html> formated string
        #
        #
        # Returns either nil or an instance of Gollum::Page
        def single_run(*argv)
          page = DependencyInjector.wiki.page(argv.first.to_s) 
          
          DependencyInjector.set({ 
            :error => DependencyInjector.config.messages.no_page_found 
          }) if page.nil? or not page.is_a?(Gollum::Page)
          
          return DependencyInjector.error if DependencyInjector.error.is_a? String and 
                                             DependencyInjector.error.length >= 2# 2digit hexcodes 00-FF
          
          DependencyInjector.set({ :page => page })
          return page
        end

        def mass_assignment(&block)

        end
      end
      
    end
  end
end
