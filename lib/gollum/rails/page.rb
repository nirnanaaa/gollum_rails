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
      def initialize(attributes = {}, options = {})
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

      ## Error String content brought by the functions in this class
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

      # Updates an existing page
      # usage:
      #
      #
      # wiki = Gollum::Rails::Wiki.new(PATH)
      #
      # page = Gollum::Rails::Page.new
      # cnt = page.find(PAGENAME)
      #
      # commit = {
      #   :message => "production test update",
      #   :name => 'Florian Kasper',
      #   :email => 'nirnanaaa@khnetworks.com'
      # }
      # update = page.update("content", commit)

      def update(content, commit, name=nil, format=nil)
        if !name.nil?
          @name = name
        end
        if !format.nil?
          @format = format
        end
        if commit.nil? || content.nil?
          @error = "commit must be given"
          return false
        end
        return @wiki.wiki.update_page(@page, @name, @format, content, commit)
      end
      
      # Deletes page fetched by find()
      def delete(commit)
        if commit.nil?
          @error = "commit must be given"
          return false
        end
        return @wiki.wiki.delete_page(@page, commit)
      end
      # if a page is loaded wraps Gollum::Page.raw_data
      def raw_data
        if @page
          @page.raw_data
        else
          @error = "no page fetched"
          return false  
        end
      end
      
      # if a page is loaded wraps Gollum::Page.formatted_data
      def formatted_data
        if @page
          @page.formatted_data
        else
          @error = "no page fetched"
          return false  
        end
      end
      
      # Active Record like
      # Page.version.first.id
      # Page.version.first.authored_data
      #
      #
      # see Active Model documentation
      def version
        if @page
          @page.versions
        else
          @error = "no page fetched"
          return false  
        end
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
        
        #super
        
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

      # Static into non static converter
      def self.method_missing(name, *args)
        klass = self.new
        return klass.send(name, args)
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