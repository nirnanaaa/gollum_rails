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
      
      # Finds an existing page or creates it
      #
      # name - The name
      # commit - Hash
      #
      # Returns self
      def find_or_initialize_by_name(name, commit={})
        result_for_find = find(name)
        unless result_for_find.nil? && result_for_find.gollum_page.nil?
          result_for_find
        else
          Page.new(:format => :markdown, :name => name, :content => ".", :commit => commit)
        end
      end

      # Checks if the fileformat is supported
      #
      # format - String
      #
      # Returns true or false
      def format_supported?(format)
        Gollum::Markup.formats.include?(format.to_sym)
      end

      # first creates an instance of itself and executes the save function.
      #
      # data - Hash containing the page data
      #
      #
      # Returns an instance of Gollum::Page or false
      def create(data)
        page = Page.new(data)
        page.save
      end


      # calls `create` on current class. If returned value is nil an exception will be thrown
      #
      # data - Hash of Data containing all necessary stuff
      # TODO write this stuff
      #
      #
      # Returns an instance of Gollum::Page
      def create!(data)
        page = Page.new(data)
        page.save!
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
      
      # TODO: implement more of this (format, etc)
      #
      def method_missing(name, *args)
        if name =~ /^find_by_(name)$/
          self.find(args.first)
        else
          raise NoMethodError, "Method #{name} was not found"
        end
      end

    end

    # Gets / Sets the gollum page
    #
    attr_accessor :gollum_page
    
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
      (@format || :markdown).to_sym
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
          @gollum_page = page.new_page(name,content,wiki,format,commit) 
        rescue ::Gollum::DuplicatePageError => e
          @gollum_page = Adapters::Gollum::Page.find_page(name, wiki)
        end
        return self
      end
    end

    # == Save without exception handling
    # raises errors everytime something is wrong 
    #
    def save!
      run_callbacks :save do
        raise StandardError, "record is not valid" unless valid?
        raise StandardError, "commit could not be empty" if commit == {}
        @gollum_page = page.new_page(name,content,wiki,format,commit)
        return self
      end
    end

    # == Updates an existing page (or created)
    #
    # content - optional. If given the content of the gollum_page will be updated
    # name - optional. If given the name of gollum_page will be updated
    # format - optional. Updates the format. Uses markdown as default
    # commit - optional. If given this commit will be used instead of that one, used
    #          to initialize the instance
    #
    #
    # Returns an instance of GollumRails::Page
    def update_attributes(content=nil,name=nil,format=:markdown, commit=nil)
      run_callbacks :update do
        @gollum_page = page.update_page(gollum_page, wiki, content, get_right_commit(commit), name, format)
      end
    end

    # == Deletes current page (also available static. See below)
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
    
    # == Previews the page - Mostly used if you want to see what you do before saving
    #
    # This is an extremely fast method!
    # 1 rendering attempt take depending on the content about 0.001 (simple markdown)
    # upto 0.004 (1000 chars markdown) seconds, which is quite good
    #
    #
    # format - Specify the format you want to render with see {self.format_supported?}
    #          for formats
    #
    # Returns a String
    def preview(format=:markdown)
      page.preview_page( wiki, name, content, format )
    end

    # == Gets the url for current page from Gollum::Page
    #
    # Returns a String
    def url
      gollum_page.url_path
    end
    
    # == Gets the title for current Gollum::Page
    #
    # Returns a String
    def title
      gollum_page.title
    end
    
    # == Gets formatted_data for current Gollum::Page
    #
    # Returns a String
    def html_data
      gollum_page.formatted_data
    end
    
    
    # == Gets raw_data for current Gollum::Page
    #
    # Returns a String
    def raw_data
      gollum_page.raw_data
    end
    
    # == Gets the history of current gollum_page
    #
    # Returns an Array
    def history
      gollum_page.versions
    end
    
    # == Gets the last modified by Gollum::Committer
    #
    # Returns a String
    def last_changed_by
      "%s <%s>" % [history.last.author.name, history.last.author.email]
    end
    
    # == Compare 2 Commits.
    #
    # sha1 - SHA1
    # sha2 - SHA1
    def compare_commits(sha1,sha2=nil)
      Page.wiki.full_reverse_diff_for(@gollum_page,sha1,sha2)
    end
    
    # == The pages filename, based on the name and the format
    # 
    # Returns a String
    def filename
      Page.wiki.page_file_name(@name, @format)
    end
      
    # == Checks if current page is a subpage
    def sub_page?
      return nil unless persisted?
      @gollum_page.sub_page
    end
    
    # == Gets the version of current commit
    #
    def current_version(long=false)
      return nil unless persisted?
      unless long
        @gollum_page.version_short 
      else
        @gollum_page.version.to_s
      end
      
    end
    
    #######
    private
    #######

    # == Gets the right commit out of 2 commits
    #
    # commit_local - local commit Hash
    #
    # Returns local_commit > class_commit
    def get_right_commit(commit_local)
      com = commit if commit_local.nil?
      com = commit_local if !commit_local.nil?
      return com
    end
    
    # == Updates local attributes from gollum_page class
    #
    def update_attrs
      @name = gollum_page.name
      @content= gollum_page.raw_data
      @format = gollum_page.format      
    end
    
    # == To static
    def wiki
      self.class.wiki
    end
    
  end
 end
