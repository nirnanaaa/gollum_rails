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
  #   * find_or_initialize_by_naname
  #
  class Page 
    extend ::ActiveModel::Callbacks
    include ::ActiveModel::Conversion
    extend ::ActiveModel::Naming
    

    # Callback for save
    define_model_callbacks :save

    # Callback for update
    define_model_callbacks :update

    # Callback for delete
    define_model_callbacks :delete

    # static
    class << self
      # Gets / Sets the gollum page
      #
      attr_accessor :gollum_page

      # Sets the validator
      attr_writer :validator

    end
    # Initializes a new Page
    #
    # attrs - Hash of attributes
    #
    # commit must be given to perform any page action!
    def initialize(attrs = {})
      if Adapters::Gollum::Connector.enabled
        attrs.each{|k,v| self.instance_variable_set("@#{k}", v)}
        attrs.each{|k,v| self.class.validator.instance_variable_set("@#{k}", v)}
      else
        raise GollumInternalError, 'gollum_rails is not enabled!'
      end
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
      @wiki || Adapters::Gollum::Connector.wiki_class
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
      @@validator ||= Adapters::ActiveModel::Validation.new
    end

    # Gets the page class
    def page
      @page ||= Adapters::Gollum::Connector.page_class.new
    end
    
    # Statically page getter
    #
    # DEPRECATED! Do not use
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
      run_callbacks :save do
        begin
          page.new_page(name,content,format,commit)
        rescue ::Gollum::DuplicatePageError => e 
          page.instance_variable_set "@page",page.find_page(name)
        end
      end
      return page.page
    end

    # aliasing save
    #
    # TODO:
    #   * implement full method!
    alias_method :save!, :save

    # first creates an instance of itself and executes the save function.
    #
    # hash - Hash containing the page data
    #
    #
    # Returns an instance of Gollum::Page or false
    def self.create(hash)
      page = Page.new hash
      page.save
    end

    # calls `create` on current class. If returned value is nil an exception will be thrown
    #
    # hash - Hash containing the page data
    #
    # TODO:
    #   * much testing
    #
    # Returns an instance of Gollum::Page
    def self.create!(hash)
      action = self.create(hash)
      if action.nil? or action.is_a? Adapters::ActiveModel::Boolean
        raise GollumInternalError, "Page is nil"
      end
      action
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
      run_callbacks :update do
        page.update_page hash, get_right_commit(commit)
      end
    end
    
    # Deletes current page (also available static. See below)
    #
    # commit - optional. If given this commit will be used instead of that one, used
    #          to initialize the instance
    #
    # Returns the commit id of the current action as String 
    def delete(commit=nil)
      run_callbacks :delete do
        page.delete_page get_right_commit(commit)
      end
    end

    # Previews the page - Mostly used if you want to see what you do before saving
    # 
    # This is an extremely performant method!
    # 1 rendering attempt take depending on the content about 0.001 (simple markdown) 
    # upto 0.004 (1000 chars markdown) seconds, which is quite good
    #
    # 
    # format - Specify the format you want to render with see {self.format_supported?}
    #          for formats
    #
    # Returns a String
    def preview(format=:markdown)
      preview = wiki.preview_page @name, @content, format
      preview.formatted_data
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

    # todo
    def valid?
      self.class.validate self,true
    end
    
    # todo
    def self.validate(context=nil,check=false,&block)
      #if block
      #  @@gollum_page = block
      #end
      #if check
      #  @@gollum_page.call context.class.validator 
      #end
    end

    # todo
    def self.register_validations_for(*args)
    end


    # module templates following:

    # empty
    #def self.method_missing(name, *args)
    #  
    #end

    # empty
    #def method_missing(name, *args)
    #end
    
    # Finds an existing page or creates it
    #
    # Returns self
    def self.find_or_initialize_by_name(name, commit)
      result_for_find = self.find(name)
      self.create({:format => :markdown, :name => name, :content => ".", :commit => commit })
    end

    def self.format_supported?(format)
      supported = ['ascii', 'github-markdown','markdown', 'creole', 'org', 'pod', 'rdoc']
      format.in?(supported)
    end

    private

    # Get the right commit out of 2 commits
    #
    # commit_local - local commit Hash
    #
    # Returns local_commit > class_commit
    def get_right_commit(commit_local)
      com = commit if commit_local.nil?
      com = commit_local if !commit_local.nil?
      return com
    end

  end
 end
