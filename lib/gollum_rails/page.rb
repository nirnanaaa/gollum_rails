# ~*~ encoding: utf-8 ~*~
require File.expand_path('../hash', __FILE__)
require File.expand_path('../page/actions.rb', __FILE__)

#require File.expand_path('../versions', __FILE__)

module GollumRails
  class Page
    include ActiveModel::Conversion
    include ActiveModel::Validations
    extend ActiveModel::Naming
    
    # Public: Singleton
    #
    # loads the necessary external classes
    #
    class << self
      DependencyInjector.page_calls.each do |hash|
        self.class.instance_eval do
          define_method(hash[0]) do |*args|
            return hash[1].single_run(*args)
          end
        end
      end
    end
    
    # Public: Gets/Sets the name of the document
    attr_accessor :name

    # Public: Gets/Sets the content of the document
    attr_accessor :content

    # Public: Gets/Sets the format of the document
    #
    # Examples
    #   Page.format = :creole
    #   #or
    #   Page.format = :markdown
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
    # Examples
    #     commit = {
    #         message: 'page created',
    #         name: 'Florian Kasper',
    #         email: 'nirnanaaa@khnetworks.com'
    #       }
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
    #
    #   GollumRails::Page.new({name: '', content: '', format: '', commit: {}})
    #
    #
    # Explanation
    #
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
      config = DependencyInjector.config

      if DependencyInjector.wiki &&
      DependencyInjector.wiki.is_a?(::Gollum::Wiki) &&
      wiki_loaded?(DependencyInjector.wiki)
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

    #    DependencyINjector.page_attributes.

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
          commit = DependencyInjector.wiki.write_page(@name, @format, @content, @commit)
        rescue Gollum::DuplicatePageError => e
          @error = e
          return false
        end
      end
      if commit and commit.is_a? String
        return commit
      else
        return false
      end
    end

    # Public: rewrite for save() method with raising exceptions as well
    def save!
      saves = save
      if @error
        raise RuntimeError, @error
      else
        return saves
      end

    end

    # Public: Updates an existing page
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
      commit = DependencyInjector.wiki.update_page(@page, @name, @format, content, commit)
      if commit.is_a?(String)
        @persisted = true
        return commit
      else
        @persisted = false
        return nil
      end
    end

    #Public: alias for update with exceptions
    def update!(content, commit, name=nil, format=nil)
      updates = update(content, commit, name=nil, format=nil)
      if @error
        raise RuntimeError, @error
      else
        return updates
      end
    end

    #Public: Deletes page fetched by find()
    def delete(commit)
      if commit.nil?
        @error = @options.messages.commit_must_be_given
        return false
      end
      return DependencyInjector.wiki.delete_page(@page, commit)
    end

    #Public: alias for delete with exceptions
    def delete!(commit)
      deletes = delete(commit)
      if @error
        raise RuntimeError, @error
      else
        return deletes
      end
    end

    #Public: For outputting all pages
    def all

    end

    # Public: Renders a preview (usable e.g. with ajax)
    #
    #
    # Returns rendered HTML
    def preview(name = nil, content = nil, format = :markdown)
      if !name or name == nil
        name = @name
      end
      if !content or content == nil
        content = @content
      end
      return DependencyInjector.wiki.preview_page(name, content, format).formatted_data
    end

    # Public: Validates class variables
    #
    #
    # Returns either true or false
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

      return true
    end

    # Public: Gets an instance of Gollum::Page
    #
    # name - Search string
    #
    # Returns nil if no result was found or no name was given
    attr_reader :page

    # Public: Finds a page based on given search string
    #
    # Be careful: At the moment you must initialize the class by .new
    #
    # Examples
    #   page = Page.new attributes
    #   page.find('static')
    #
    # Returns either nil or an instance of Gollum::Page
    def find(name = nil)
      if !name.nil?
        page = DependencyInjector.wiki.page(name)
        if page.nil?
          @error = @options.messages.no_page_found
          return nil
        end

        #need a better solution. Thats fu***** bull*****
        @page = page
        @name = page.name
        @format = page.format

        return page
      else
        @error = @options.messages.name_not_set_or_nil
        return nil
      end
    end

    # Public: Checks if the object is already persisted
    #
    # Examples
    #   page = Page.new
    #   page.persisted?
    #   # => false
    #   page.save
    #   page.persisted?
    #   # => false
    #
    #   @commit = {
    #     :message => "test creation of page",
    #     :name => 'Florian Kasper',
    #     :email => 'nirnanaaa@khnetworks.com'
    #   }
    #   attributes = {
    #     name: 'TestPage',
    #     content: 'content',
    #     format: :markdown,
    #     commit: @commit
    #   }
    #   page.save
    #   page.persisted?
    #   # => true
    #
    # Returns a Boolean(false|true)
    def persisted?
      @persisted
    end

    # Public: Magic method ( static )
    #
    # name - The functions name
    # args - Pointer of arguments
    #
    # Static into non static converter
    #   def self.method_missing(name, *args)
    #klass = self.new
    #return klass.find(args) if name.to_s == 'find'
    #      klass = Actions.perform(name, *args)
    #  end

    ################################################
    ######### P A G E # L O A D E D ################
    ################################################

    # Public: A simple wrapper for Gollum::Page.raw_data
    #
    # Page needs to be loaded!
    #
    # Returns raw data
    def raw_data
      if @page
        @page.raw_data
      else
        @error = @options.messages.no_page_fetched
        return false
      end
    end

    # Public: A simple wrapper for Gollum::Page.formatted_data
    #
    # Page needs to be loaded!
    #
    # Returns formatted html
    def formatted_data
      if @page
        @page.formatted_data
      else
        @error = @options.messages.no_page_fetched
        return false
      end
    end

    # Public: Active Record like
    #
    #
    #
    # see Active Model documentation
    def versions
      if @page && @page.is_a?(Gollum::Page) #&& (persisted? || found?)
        return GollumRails::Versions.new(@page)
      else
        @error = @options.messages.no_page_fetched
        return false
      end
    end

  end
end
