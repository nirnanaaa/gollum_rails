module GollumRails
  module Finders
    extend ActiveSupport::Concern
    module ClassMethods
      # Finds an existing page or creates it
      #
      # name - The name
      # commit - Hash
      #
      # Returns self
      def find_or_initialize_by_name(name, commit={})
        result_for_find = find(name)
        unless result_for_find.nil?
          result_for_find
        else
          new(:format => :markdown, :name => name, :content => ".", :commit => commit)
        end
      end
      
      # Finds a page based on the name and specified version
      #
      # name - the name of the page
      # version - optional - The pages version
      #
      # Return an instance of Gollum::Page
      def find(name, version=nil)
        page = Adapters::Gollum::Page.find_page(name, wiki, version)
        
        return new( :gollum_page => page ) unless page.nil?
        return nil
        
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
      def all
        wiki.pages
      end
      
      alias_method :find_all, :all
      
      # TODO: implement more of this (format, etc)
      #
      def method_missing(name, *args)
        if name =~ /^find_by_(name)$/
          self.find(args.first)
        else super
        end
      end
      
      
    end
  end
end