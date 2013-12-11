module GollumRails
  module Persistance
    extend ActiveSupport::Concern
    
    module ClassMethods
      
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
      return nil unless valid?
      begin
        @gollum_page = page.new_page(name,content,wiki,format,commit) 
      rescue ::Gollum::DuplicatePageError => e
        @gollum_page = Adapters::Gollum::Page.find_page(name, wiki)
      end
      return self
    end

    # == Save without exception handling
    # raises errors everytime something is wrong 
    #
    def save!
      raise StandardError, "record is not valid" unless valid?
      raise StandardError, "commit could not be empty" if commit == {}
      @gollum_page = page.new_page(name,content,wiki,format,commit)
      return self
    end
  end
end