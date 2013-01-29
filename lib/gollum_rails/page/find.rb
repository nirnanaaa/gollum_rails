module GollumRails
  module PageActions
    class Find < GollumRails::PageHelper
      call_by 'find'
      
      class << self
        def initialized_first
          #self.instance_variable_set("@wiki")
          
          super
        end

        # Public: Finds a page based on given search string
        #
        # Be careful: At the moment you must initialize the class by .new
        #
        # Examples
        #   page = Page.new attributes
        #   page.find('static')
        #
        # Returns either nil or an instance of Gollum::Page
        def single_run(*argv)
          puts argv
          page = DependencyInjector.wiki.page(argv.first.to_s) 
          
          DependencyInjector.set({ 
            :error => DependencyInjector.config.messages.no_page_found 
          }) if page.nil? or not page.is_a?(Gollum::Page)
          
          return DependencyInjector.error if DependencyInjector.error.is_a? String and 
                                             DependencyInjector.error.length >= 2
          
          DependencyInjector.set({ :page => page })
          return page
        end

        def mass_assignment(&block)

        end
      end
      
    end
  end
end
