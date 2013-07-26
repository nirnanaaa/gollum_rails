require 'thread'

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
  #   * find_or_initialize_by_name
  #
  class Page
    include ::ActiveModel::Model


    # Callback for save
    define_model_callbacks :save

    # Callback for update
    define_model_callbacks :update

    # Callback for delete
    define_model_callbacks :delete
    
    # Callback for initialize
    define_model_callbacks :initialize
    
    # Callback for create
    define_model_callbacks :create

    # Callback for commit
    define_model_callbacks :commit
    
    # static
    class << self
      
      # Gets / Sets the gollum page
      #
      attr_accessor :gollum_page

      # Sets the validator
      attr_writer :validator

      # Finds an existing page or creates it
      #
      # name - The name
      # commit - Hash
      #
      # Returns self
      def find_or_initialize_by_name(name, commit)
        result_for_find = find(name)
        create({:format => :markdown, :name => name, :content => ".", :commit => commit })
      end

      # Checks if the fileformat is supported
      #
      # format - String
      #
      # Returns true or false
      def format_supported?(format)
        supported = ['ascii', 'github-markdown','markdown', 'creole', 'org', 'pod', 'rdoc']
        format.in?(supported)
      end

      # first creates an instance of itself and executes the save function.
      #
      # hash - Hash containing the page data
      #
      #
      # Returns an instance of Gollum::Page or false
      def create(hash)
        page = Page.new(hash)
        page.save
      end


      # calls `create` on current class. If returned value is nil an exception will be thrown
      #
      # hash - Hash containing the page data
      #
      #
      # Returns an instance of Gollum::Page
      def create!(hash)
        create(hash)
      end

      # Finds a page based on the name and specified version
      #
      # name - the name of the page
      #
      # Return an instance of Gollum::Page
      def find(name)
        self.new(gollum_page: Adapters::Gollum::Page.find_page(name, wiki))
      end

      # Gets all pages in the wiki
      def all
        wiki.pages
      end
      
      alias_method :find_all, :all

      # Gets the wiki instance
      def wiki
        @wiki ||= ::Gollum::Wiki.new(Adapters::Gollum::Connector.wiki_path, Adapters::Gollum::Connector.wiki_options)
      end

    end

    def wiki
      self.class.wiki
    end
    # Initializes a new Page
    #
    # attrs - Hash of attributes
    #
    # commit must be given to perform any page action!
    def initialize(attrs = {})
      if Adapters::Gollum::Connector.enabled
        attrs.each{|k,v| self.public_send("#{k}=",v)} if attrs
        update_attrs if attrs[:gollum_page]
      else
        raise GollumInternalError, 'gollum_rails is not enabled!'
      end
    end

    #########
    # Setters
    #########


    # Gets / Sets the pages name
    attr_accessor :name

    # Gets / Sets the contents content
    attr_accessor :content

    # Gets / Sets the commit Hash
    attr_accessor :commit

    # Sets the format
    attr_writer :format


    #########
    # Getters
    #########


    # Gets the pages format
    def format
      @format.to_sym
    end


    # Gets the page class
    def page
      Adapters::Gollum::Page.new
    end
    
    # Gollum Page
    attr_accessor :gollum_page

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
        return nil unless valid?
        begin
          gollum_page = page.new_page(name,content,wiki,format,commit) 
        rescue ::Gollum::DuplicatePageError => e
          gollum_page = Adapters::Gollum::Page.find_page(name, wiki)
        end
        return self
      end
    end

    # aliasing save
    #
    # TODO:
    #   * implement full method!
    alias_method :save!, :save

    # Updates an existing page (or created)
    #
    # TODO
    # commit - optional. If given this commit will be used instead of that one, used
    #          to initialize the instance
    #
    #
    # Returns an instance of Gollum::Page
    def update_attributes(content=nil,name=nil,format=:markdown, commit=nil)
      run_callbacks :update do
        gollum_page = page.update_page(gollum_page, wiki, content, get_right_commit(commit), name, format)
        puts gollum_page
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
        page.delete_page(gollum_page, wiki, get_right_commit(commit))
      end
    end

    # checks if entry already has been saved
    #
    #
    def persisted?
      return true if gollum_page
      return false
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
      preview = self.class.wiki.preview_page @name, @content, format
      preview.formatted_data
    end

    def url
      gollum_page.url_path
    end
    
    #######
    private
    #######

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
    

    def update_attrs
      @name = gollum_page.name
      @content= gollum_page.raw_data
      @format = gollum_page.format      
    end

  end
 end
