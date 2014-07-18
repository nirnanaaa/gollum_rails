module GollumRails
  module Persistance
    extend ActiveSupport::Concern

    class AttributeMissingError < NoMethodError; end

    module ClassMethods

      # first creates an instance of itself and executes the save function.
      #
      # data - Hash containing the page data
      #
      #
      # Returns an instance of Gollum::Page or false
      def create(data)
        page = self.new(data)
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
        page = self.new(data)
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
        create_or_update
      rescue ::Gollum::DuplicatePageError
      end
      self.gollum_page = wiki.paged(file_name, path_name, true, wiki.ref)
      _update_page_attributes
      self
    end

    # == Save without exception handling
    # raises errors everytime something is wrong
    #
    # Returns an instance of GollumRails::Page
    def save!
      raise StandardError, "record is not valid" unless valid?
      raise StandardError, "commit must not be empty" if commit == {}
      create_or_update
      self
    end

    # == Creates a record or updates it!
    #
    # Returns a Commit id string
    def create_or_update
      if persisted?
        update_record
      else
        create_record
      end
    end

    # == Creates a record
    #
    # Returns a Commit id
    def create_record
      wiki.write_page(canonicalized_filename, format, content, commit, path_name)
      wiki.clear_cache
    rescue NoMethodError => e
      raise AttributeMissingError, "Attributes are missing. Error message: <%s>" % e.message
    end

    # == Update a record
    #
    # Updates a record based on current instance variables
    #
    # returns a Commit id
    def update_record
      wiki.update_page(self.gollum_page,
                       self.name,
                       self.format,
                       self.content,
                       self.commit)
    end

    # == Updates an existing page (or created)
    #
    # attributes - Hash of arguments
    #
    # Returns an instance of GollumRails::Page
    def update_attributes(attributes)
      assign_attributes(attributes)
      save
    end

    def seperate_path(path) #:nodoc:
      path = File.split(name)
      if path.first == '/' || path.first == '.'
        folder = nil
      else
        folder = path.first
      end
    end

    # == Deletes current page
    #
    # commit - optional. If given this commit will be used instead of that one, used
    #          to initialize the instance
    #
    # Returns the commit id of the current action as String
    def destroy(commit=nil)
      return false if @gollum_page.nil?
      wiki.delete_page(@gollum_page, get_right_commit(commit))
    end

    # == Deletes current page
    #
    # commit - optional. If given this commit will be used instead of that one, used
    #          to initialize the instance
    #
    # Returns the commit id of the current action as String
    def delete(commit=nil)
      destroy(commit)
    end

    # checks if entry already has been saved
    #
    #
    def persisted?
      return true if gollum_page
      return false
    end
  end
end
