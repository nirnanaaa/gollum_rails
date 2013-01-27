# ~*~ encoding: utf-8 ~*~
require "gollum_rails/hash"

module GollumRails
    class Page 
      include ActiveModel::Conversion
      include ActiveModel::Validations
      extend ActiveModel::Naming

      # Public: Gets/Sets the name of the document
      attr_accessor :name

      # Public: Gets/Sets the content of the document
      attr_accessor :content

      # Public: Gets/Sets the format of the document
      # 
      # Examples
      # Page.format = :creole
      # #or
      # Page.format = :markdown
      # 
      # Possible formats are
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

      # Public: Gets/Sets the commiters credentials
      #
      # commit - The commit Hash details:
      #   :message - The String commit message.
      #   :name - The String author full name.
      #   :email - The String email address.
      #   :parent - Optional Grit::Commit parent to this update.
      #   :tree - Optional String SHA of the tree to create the
      #           index from.
      #   :committer - Optional Gollum::Committer instance. If provided,
      #                assume that this operation is part of batch of
      #                updates and the commit happens later.
      # 
      # Examples:
      #     commit = {
      #       message: 'page created',
      #       name: 'Florian Kasper',
      #       email: 'nirnanaaa@khnetworks.com'
      #     }
      #  
      attr_accessor :commit



      #########
      # READERs
      #########
      
      # Public: Gets the options
      attr_reader :options

      # Public: Gets the persistance of objects by save(), update(), delete() methods
      attr_reader :persisted
      
      # Public: Gets the error messages
      attr_reader :error

      # Public: Gets the instance of Gollum::Wiki
      attr_reader :wiki
      
      # Public: Gets ?!
      attr_reader :class
      
      # Public: Initializes a new Page instance
      #
      # attributes - A hash of attributes. See example
      # options - Will be merged with the configuration 
      #
      # Examples
      #   GollumRails::Page.new({name: '', content: '', format: '', commit: {}})
      #
      #
      # Explanation:
      #   name must be a string.
      #   content should be a text/String
      #   format must be eighter :markdown, :latex, :rdoc, ...
      #   commit must be a hash for example:
      #
      # Raises RuntimeError if the wiki was not initialized
      # Raises RuntimeError if no configuration was provided
      #
      # Returns an instance of this class
      def initialize(attributes = {}, options = {})
        wiki = DependencyInjector.wiki
        config = DependencyInjector.config
        if wiki && wiki.is_a?(Wiki) && wiki_loaded?(wiki.wiki)
          @wiki = wiki
        else
          #must be hardcoded, cause no options are loaded
          raise RuntimeError, "No wiki loaded"
        end
        if config && config.is_a?(Hash)
          @options = config
          options.each{|k,v| @options[k] = v}
        else
          raise RuntimeError, "No configuration provided"
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

      # Public: Checks if the given Instance is an Instance of the Gollum Wiki
      # 
      # wiki - An instance of a class
      # 
      # Examples
      #   wiki_loaded?(Gollum::Wiki)
      #   # => true
      #
      # Returns if the given instance is an instance of Gollum::Wiki
      def wiki_loaded?(wiki)
        wiki.is_a?(Gollum::Wiki)
      end

      # Public: Gets the @error message 
      #
      # Examples:
      #   puts get_error_message
      #   # => 'An Error Occured'
      #
      # Returns an Error message
      def get_error_message
        @error
      end

      # Public: saves this instance
      
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

      #rewrite for save() method with raising exceptions as well
      def save!
        saves = save
        if @error
          raise RuntimeError, @error
        else
          return saves
        end
        
      end
      
      # Updates an existing page
      # usage:
      #
      #
      # wiki = GollumRails::Wiki.new(PATH)
      #
      # page = GollumRails::Page.new
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
          @error = @options.messages.commit_not_empty_and_content_not_empty
          return false
        end
        return @wiki.wiki.update_page(@page, @name, @format, content, commit)
      end
      
      # alias for update with exceptions
      def update!(content, commit, name=nil, format=nil)
        updates = update(content, commit, name=nil, format=nil)
        if @error
          raise RuntimeError, @error
        else
          return updates
        end
      end
      
      # Deletes page fetched by find()
      def delete(commit)
        if commit.nil?
          @error = @options.messages.commit_must_be_given
          return false
        end
        return @wiki.wiki.delete_page(@page, commit)
      end
      
      # alias for delete with exceptions
      
      def delete!(commit)
        deletes = delete(commit)
        if @error
          raise RuntimeError, @error
        else
          return deletes
        end
      end
      
      def all
        
      end
      
      def preview(name = nil, content = nil, format = :markdown)
        if !name or name == nil
          name = @name
        end
        if !content or content == nil
          content = @content
        end
        return @wiki.wiki.preview_page(name, content, format)
      end
      # if a page is loaded wraps Gollum::Page.raw_data
      def raw_data
        if @page
          @page.raw_data
        else
          @error = @options.messages.no_page_fetched
          return false  
        end
      end
      
      # if a page is loaded wraps Gollum::Page.formatted_data
      def formatted_data
        if @page
          @page.formatted_data
        else
          @error = @options.messages.no_page_fetched
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
          @error = @options.messages.no_page_fetched
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
          @error = @options.messages.name_not_set_or_nil
          return false
        end
        if !@commit || !@commit.is_a?(Hash)
          @error = @options.messages.commit_must_be_given
          return false
        end
        if !@format
          @error = @options.messages.format_not_set
          return false
        end    
        
        #super #doesn't work atm
        
        return true
      end

      
      #gets an Instance of Gollum::Wiki fetched by find() method
      attr_reader :page

      #finds a wiki page
      def find(name = nil)
        if !name.nil?
          page = @wiki.wiki.page(name)
          if page.nil?
            @error = @options.messages.no_page_found
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