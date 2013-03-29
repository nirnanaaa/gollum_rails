module GollumRails
  module Adapters
    module Gollum

      # TODO: doc
      class Page
        
        # Gets / Sets current page
        attr_accessor :page

        # Gets / Sets the wiki
        attr_accessor :wiki

        # Initializer
        def initialize
          wiki = GollumRails::Adapters::Gollum::Wiki.class_variable_get(:@@wiki)
          if wiki.is_a? ::Gollum::Wiki
            @wiki = wiki
          else
            Error.new('initialized wiki is not an instance of Gollum::Wiki')
          end
        end


        # creates a new Page
        #
        # Returns the commit id
        def new_page()
        end

        # updates an existing page
        #
        # Returns the commit id
        def update_page()
        end

        # deletes an existing page
        #
        # Returns the commit id
        def delete_page()
        end
        
        # renames an existing page
        #
        # Returns the commit id
        def rename_page()
        end
        
        # moves an existing page
        def move_page()
        end

      end
    end
  end
end
