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

        class << self

          # == Parses a given filepath e.g. '/test/page'
          # Name is page
          # path is /test
          #
          # Returns a Hash
          def parse_path(name)
            path = '/'
            name = name.to_s
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
          # version - optional - The pages version
          #
          # Returns the Gollum::Page class
          def find_page(name, wiki, version=nil)
            wiki.clear_cache
            path_data = parse_path(name)
            wiki.paged(path_data[:name], path_data[:path], exact = true, version)
          end
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
          wiki.clear_cache
          return page if page.nil?
          name ||= page.name
          format = (format || page.format).to_sym
          content ||= page.raw_data
          
          wiki.update_page(page,name,format,content.to_s,commit) unless ((!content||page.raw_data == content) && page.format == format)
          
          self.class.find_page( mixin(page.url_path, name), wiki )
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
