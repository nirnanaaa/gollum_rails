# ~*~ encoding: utf-8 ~*~
module Gollum
  module Rails
    class Page
      include ActiveModel::Conversion
      extend ActiveModel::Naming

      #the filename
      attr_accessor :name

      # text content
      attr_accessor :content

      # file formatting type
      # possible:
      #  - :asciidoc
      #  - :creole
      #  - :markdown
      #  - :org
      #  - :pod
      #  - :rdoc
      #  - :rst
      #  - :tex
      #  - :wiki
      attr_accessor :format

      # the commit Hash
      attr_accessor :commit

      # WHAT?!
      attr_accessor :options

      # a boolean variable that holds the status of save() and update()
      attr_reader :persisted
      
      # holds the error messages
      attr_reader :error
      
      # holds an instance of Gollum::Wiki
      attr_reader :wiki
         
      # attributes needs to be a hash
      # example:
      #   Gollum::Rails::Page.new({name: '', content: '', format: '', commit: {}})
      #
      #
      # explanation:
      # name must be a string.
      # content should be a text/String
      # format must be eighter :markdown, :latex, :rdoc, ...
      # commit must be a hash for example:
      #   commit = {
      #      message: 'page created',
      #      name: 'Florian Kasper',
      #      email: 'nirnanaaa@khnetworks.com'
      #   }
      def initialize(attributes, options = {})
        wiki = DependencyInjector.get('wiki')
        if wiki && wiki.is_a?(Wiki)
          @wiki = wiki
        end
        if !Validations.is_boolean?(@persisted)
          @persisted = false
        end
        if !@error
          @error = nil
        end
        attributes.each do |name, value|
          send("#{name}=", value)
        end

      end
      
      ## checks if @wiki.wiki is an instance of Gollum::Wiki
      def wikiLoaded?
        @wiki.wiki.is_a?(Gollum::Wiki)
      end
      
      def get_error_message
        @error
      end
      # Some "ActiveRecord" like things e.g. .save .valid? .find .find_by_* .where and so on
      def save
        if valid?
          begin
            @wiki.wiki.write_page(@name, @format, @content, @commit)
            @persisted = true
          rescue Gollum::DuplicatePageError => e
            @error = e
            return false
          end
        end
        return true
      end

      def update(content, commit, name=nil, format=nil)
        if !name.nil?
          @name = name
        end
        if !format.nil?
          @format = format
        end
        if commit.nil? || content.nil?
          return false
        end
        @wiki.wiki.update_page(@page, @name, @format, content, commit)
      end
      
      ## if a page is loaded
      def get_raw_data
        
      end
      def version
        
      end
      def get_formatted_data
        
      end
      
      #
      # Validates the Class variables
      # default:
      #  - name must be set
      #  - content can be NIL || " "
      #  - committer must be set
      # format must be set
      def valid?
        if !@name || @name.nil?
          return false
        end
        if !@commit || !@commit.is_a?(Hash)
          return false
        end
        if !@format
          return false
        end
        return true
        
      end
      
      #gets an Instance of Gollum::Wiki fetched by find() method
      attr_reader :page
      
      #finds a wiki page
      def find(name = nil)
        if !name.nil?
            page = @wiki.wiki.page(name)
            if page.nil?
              @error = "The given page was not found"
              return nil
            end
            
            #need a better solution thats fu***** bull*****
            @page = page
            @name = page.name
            @format = page.format

            return page
        else
          return nil
        end
      end

      def persisted?
        @persisted
      end

    #  def method_missing(name, *args)
    #      meth = name.to_s.index("find_by_")
    #      if meth.nil?
    #        @error = "method not found"
    #        raise RuntimeError
    #      end
    #      finder = name[8 .. name.length]
    #      if finder == "name"
           # find(args)
    #      end
    #  end

    end
  end
end