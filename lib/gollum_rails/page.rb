module GollumRails

  # Main class, used to interact with rails.
  #
  # Methods, which are available:
  #   * find
  #   * update_attributes
  #   * find_by_*
  #   * create
  #   * new
  #   * save
  #   * delete
  #   * find_or_initialize_by_id
  #
  class Page < Adapters::ActiveModel::Callback
    include ::ActiveModel::Conversion
    extend ::ActiveModel::Naming
    
    # Gets / Sets the gollum page
    attr_accessor :gollum_page

    # Initializes a new Page
    #
    #
    # if save() or create() is called, the 
    def initialize(attrs)
      attrs.each{|k,v| self.instance_variable_set("@#{k}", v)}
    end

    #########
    # Setters
    #########
     
    # Sets the wiki instance
    attr_writer :wiki

    # Sets the pages name
    attr_writer :name

    # Sets the contents content
    attr_writer :content

    # Sets the commit Hash
    attr_writer :commit

    # Sets the format
    attr_writer :format

    # Sets the page
    attr_writer :page
    
    #########
    # Getters
    #########

    # Gets the wiki instance
    def wiki
      @wiki || Adapters::Gollum::Connector.wiki_class.class_variable_get(:@@wiki)
    end

    # Gets the pages' name
    def name
      @name || @gollum_page.name
    end

    # Gets the raw content of the current page
    def content
      @content || @gollum_page.raw_content
    end

    # Need to implement the Committer connector (forgot it completely)
    # Gets the commit Hash from current object
    def commit
      @commit
    end

    # Gets the pages format
    def format
      (@format || @gollum_page.format).to_sym
    end

    # Gets the validator
    def self.validator
      Adapters::ActiveModel::Validation
    end

    # Gets the page class
    def page
      @page ||= Adapters::Gollum::Connector.page_class.new
    end
    
    def self.page
      Adapters::Gollum::Connector.page_class
    end

    #############
    # activemodel
    #############

    # Handles the connection betweet plain activemodel and Gollum
    # Saves current page in GIT wiki
    # If another page with the same name is existing, gollum_rails
    # will detect it and returns that page instead.
    #
    # Examples:
    #   
    #   obj = GollumRails::Page.new <params>
    #   @article = obj.save
    #   # => Gollum::Page
    #   
    #   @article.name
    #   whatever name you have entered OR the name of the previous 
    #   created page
    #       
    #
    # TODO:
    #   * overriding for creation(duplicates)
    #   * do not alias save! on save 
    # 
    # Returns an instance of Gollum::Page or false
    def save
      begin
        page.instance_variable_set("@page", page.new_page(name, content, format, commit)) if valid?
        return page.page||false
      rescue ::Gollum::DuplicatePageError => e 
        page.instance_variable_set "@page",page.find_page(name)
        return page.page 
      end
    end
    alias_method :save!, :save

    # first creates an instance of itself and executes the save function.
    #
    # hash - Hash containing the page data
    #
    # TODO:
    #   * implement an create! function
    #   * document and test
    #
    # Returns an instance of Gollum::Page or false
    def self.create(hash)
      page = Page.new hash
      page.save
    end

    # Updates an existing page (or created)
    #
    # hash - Hash containing the attributes, you want to update
    # commit - optional. If given this commit will be used instead of that one, used
    #          to initialize the instance
    #
    #
    # Returns an instance of Gollum::Page 
    def update_attributes(hash, commit=nil)
      page.update_page hash, get_right_commit(commit)

    end
    
    # Deletes current page (also available static. See below)
    #
    # commit - optional. If given this commit will be used instead of that one, used
    #          to initialize the instance
    #
    # Returns the commit id of the current action as String 
    def delete(commit=nil)
      page.delete_page get_right_commit(commit)
    end

    # Finds a page based on the name and specified version
    #
    # name - the name of the page
    #
    # Return an instance of Gollum::Page
    def self.find(name)
      page = GollumRails::Adapters::Gollum::Page.new
      page.find_page name
    end

    # Checks if 
    def valid?
      true
    end
    def self.validate(&block)
      validator = self.validator.new
      block.call validator 
    end
    def self.register_validations_for(*args)
      context = <<-END
      END
      self.validator.class_eval(context)
    end


    # module templates following:



    def self.method_missing(name, *args)
    end
    def method_missing(name, *args)
    end
    
    def self.find_or_initialize_by_id
    end

    def self.format_supported?(format)
      supported = ['ascii', 'github-markdown','markdown', 'creole', 'org', 'pod', 'rdoc']
      format.in?(supported)
    end

    private

    def get_right_commit(commit_local)
      com = commit if commit_local.nil?
      com = commit_local if !commit_local.nil?
      return com
    end

  end
 end
