module GollumRails
  module Core
    extend ActiveSupport::Concern
    
    module ClassMethods
      
      # Checks if the fileformat is supported
      #
      # format - String
      #
      # Returns true or false
      def format_supported?(format)
        Gollum::Markup.formats.include?(format.to_sym)
      end
      
      # Gets the wiki instance
      def wiki
        @wiki ||= ::Gollum::Wiki.new(Adapters::Gollum::Connector.wiki_path, Adapters::Gollum::Connector.wiki_options)
      end
      
    end
    
    def path_name
      name.gsub(/(^\/|(\/){2}+|#{canonicalized_filename})/, "")
    end
    
    def canonicalized_filename
      Gollum::Page.canonicalize_filename(name)
    end
    
  end
end