module GollumRails
  module Finders
    extend ActiveSupport::Concern
    module ClassMethods

      # Find an existing page or create it
      #
      # name - The name
      # commit - Hash
      #
      # Returns self
      def find_or_initialize_by_name(name, commit={})
        result = find(name)
        if result
          result
        else
          new(:format => :markdown, :name => name, :content => ".", :commit => commit)
        end
      end

      # Finds a page based on the name and specified version
      #
      # name - the name of the page
      # version - optional - The pages version
      # folder_reset - optional - resets the folder to / before performing the search
      # exact - optional - perform an exact match
      #
      # Return an instance of Gollum::Page
      def find(name, version=nil, folder_reset=false, exact=true)
        name = name[:name] if name.kind_of?(Hash) && name.has_key?(:name)
        Page.reset_folder if folder_reset
        wiki.clear_cache
        path = File.split(name)
        if path.first == '/' || path.first == '.'
          folder = nil
        else
          folder = path.first
        end
        page = wiki.paged(path.last, folder, exact, version)
        if page
          new(gollum_page: page)
        else
          nil
        end
      end

      # == Searches the wiki for files CONTENT!
      #
      # string - Searchstring
      #
      # Returns an Array
      def search(string)
        wiki.search(string)
      end

      # Gets all pages in the wiki
      #
      # Returns an Array with GollumRails::Page s
      def all(options={})
        set_folder(options)
        pages = wiki.pages
        pages.map do |page|
          self.new(gollum_page: page)
        end
      end

      # Gets the last item from `all` method call
      #
      # options - optional - some options e.g. :folder
      #
      # Returns a single GollumRails::Page
      def first(options={})
        all(options).first
      end

      # Gets the first item from `all` method call
      #
      # options - optional - some options e.g. :folder
      #
      # Returns a single GollumRails::Page
      def last(options={})
        all(options).last
      end

      # Aliasing this for ActiveRecord behavior
      alias_method :find_all, :all

      # Catch-all method
      def method_missing(name, *args)
        if name =~ /^find_by_(name)$/
          self.find(args.first)
        else super
        end
      end
    end
  end
end
