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
        # name - String
        # type - Symbol
        # content - Text
        # commit - Hash or instance of Committer
        #
        # Returns the commit id
        def new_page( name, type = :markdown, content, commit = {} )
        end

        # updates an existing page
        #
        # page - instance of self
        # commit - Hash or instance of Committer
        #
        # Returns the commit id
        def update_page( page, commit = {})
        end

        # deletes an existing page
        #
        # page - instance of self
        # commit - Hash or instance of Committer
        #
        # Returns the commit id
        def delete_page( page, commit = {} )
        end
        
        # renames an existing page
        #
        # page - instance of myself
        # newname - new pagename
        # commit - Hash or instance of Committer
        #
        # Returns the commit id
        def rename_page( page, newname, commit = {} )
        end
        
        # moves an existing page
        #
        # TODO:
        #   * implement
        def move_page()
        end

      end
    end
  end
end
