module GollumRails
  module Adapters
    module Gollum

      # Main page class for the Gollum connector.
      #
      # It provides some awesome features for connecting gollum to gollum_rails such as:
      #   * new_page
      #   * find_page
      #   * delete_page
      #   * rename_page
      #   * move_page
      #   * first_page_commit
      #   * page_creation time
      #   * ...
      #
      class Page

        Connector.page_class = self

        # Gets / Sets current page
        attr_accessor :page

          # Gets / Sets the wiki
        attr_accessor :wiki

        # Initializer
        def initialize
          @wiki = Connector.wiki_class
        end


        # creates a new Page
        #
        # name - String
        # type - Symbol
        # content - Text
        # commit - Hash or instance of Committer
        #
        # Returns the commit id
        def new_page( name, content,type=:markdown, commit={} )
          @wiki.write_page name.to_s, type, content, commit if name
          @page = @wiki.page name
          @page
        end

        # updates an existing page
        #
        # new - Hash with changed data
        # commit - Hash or instance of Committer
        # old - also an instance of self
        #
        # Returns the commit id
        def update_page( new, commit={}, old=nil)
          if new.is_a?(Hash)
            commit_id = @wiki.update_page (old||@page), 
                                          new[:name]||@page.name, 
                                          new[:format]||@page.format, 
                                          new[:content]||@page.raw_data, 
                                          commit 
          else
            raise Error.new  "commit must be a Hash. #{new.class} given", :crit
          end

          # this is very ugly. Shouldn't gollum return the new page?
          @page = @page.find(new[:name]||@page.name, commit_id)
          @page
        end

        # deletes an existing page
        #
        # page - instance of self
        # commit - Hash or instance of Committer
        #
        # Returns the commit id
        def delete_page( commit={}, page = nil )
          @wiki.delete_page (page||@page), commit
        end
        
        # renames an existing page
        #
        # page - instance of myself
        # newname - new pagename
        # commit - Hash or instance of Committer
        #
        # Returns the commit id
        def rename_page( page, newname, commit={} )

        end

        # finds all versions of a page
        #
        # name - the pagename to search
        #
        # Returns the Gollum::Page class
        def find_page(name)
          @wiki.page ::Gollum::Page.cname(name)
        end
        
        # moves an existing page
        #
        # TODO:
        #   * implement
        def move_page()
        end

        # gets page last edit date
        #
        # Returns an instance of Time
        def page_last_edited_date
          if @page
            return @page.versions.first.authored_date
          else
            raise Error.new  "page cannot be empty for #{__method__}", :high
          end
        end

        # gets the latest commit
        #
        # Returns an instance of Grit::Commit
        def page_last_commit
          if @page
            return @page.versions.first
          else
            raise Error.new "page cannot be empty for #{__method__}", :high
          end
        end

        # gets the creation date of the page
        #
        # Returns an instance of Time
        def page_created
          if @page
            return @page.versions.last.authored_date
          else
            raise Error.new  "page cannot be empty for #{__method__}", :high
          end

        end
        
        # gets the first page commit
        #
        # Returns an instance of Grit::Commit
        def page_first_commit
          if @page
            return @page.versions.last
          else
            raise Error.new  "page cannot be empty for #{__method__}", :high
          end
        end

        # gets a specific commit version
        #
        # Returns an instance of Grit::Commit
        def page_commit(id)
          if @page
            return @page.versions.each{|v| return v if v.id == id}
          else
            raise Error.new  "page cannot be empty for #{__method__}", :high
          end
        end

        # gets a specific commit time
        #
        # Returns an instance of Time
        def page_commit_date(id)
          if @page
            return @page.versions.each{|v| return v.authored_date if v.id == id}
          else
            raise Error.new  "page cannot be empty for #{__method__}", :high
          end
        end

      end
    end
  end
end
