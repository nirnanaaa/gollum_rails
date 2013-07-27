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

        class << self

          def parse_path(name)
            path = '/'
            if name.include?('/')
              name = name[1..-1] if name[0] == "/"
              content = name.split('/')
              name = content.pop
              path = '/'+content.join('/')
            end
            { path: path, name: name }
          end
          
          # finds all versions of a page
          #
          # name - the pagename to search
          # wiki - instance of Gollum::Wiki
          #
          # Returns the Gollum::Page class
          def find_page(name, wiki)
            path_data = parse_path(name)
            wiki.paged(path_data[:name], path_data[:path], exact = true)
          end
        end

        # == Creates a new page
        #
        # name - The name of the page
        # content - The content of the page
        # wiki - An instance of Gollum::Wiki
        # type - A filetype as symbol (optional)
        # commit - Commit Hash
        #
        # Returns the page
        def new_page( name, content, wiki, type=:markdown, commit={} )
          path_data = self.class.parse_path(name)
          wiki.write_page( path_data[:name], type, content, commit, path_data[:path].gsub!(/^\//, "").gsub!(/(\/)+$/,'') || "" )
          self.class.find_page( name, wiki )
        end

        # == Updates an existing page
        #
        # page - An instance of Gollum::Page
        # wiki - An instance of Gollum::Wiki
        # content - New content
        # commit - Commit Hash
        # name - A new String (optional)
        # format - A filetype as symbol (optional)
        #
        # Returns the page
        def update_page( page, wiki, content=nil, commit={}, name=nil, format=nil)
          return if !page || ((!content||page.raw_data == content) && page.format == format)
          name ||= page.name
          format = (format || page.format).to_sym
          content ||= page.raw_data
          wiki.update_page(page,name,format,content.to_s,commit)
          self.class.find_page( mixin(page.url_path, name), wiki )
        end
        
        # == Preview page
        #
        # wiki - An instance of Gollum::Wiki
        # content - New content
        # name - A String
        # format - A filetype as symbol (optional)
        #
        def preview_page(wiki, name, content, format=:markdown)
          page = wiki.preview_page(name,content,format)
          page.formatted_data
        end

        # == Deletes an existing page
        #
        # page - Gollum::Page
        # wiki - Gollum::Wiki
        # commit - Commit Hash
        #
        # Returns the commit id
        def delete_page( page,wiki,commit={} )
          wiki.delete_page(page, commit)
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
          self.class.find_page(name)
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
        
        private
        
        # replaces old filename with new
        def mixin(old_url, new_name)
          url = old_url.split("/")
          url.pop
          url << new_name
          url.join("/")
        end

      end
    end
  end
end
