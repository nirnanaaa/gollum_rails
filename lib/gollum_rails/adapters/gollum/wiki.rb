require 'grit'
module GollumRails
  module Adapters
    module Gollum

      # TODO: doc
      class  Wiki

        # Initializes the class
        #
        # location - String or Grit::Repo
        def initialize(location, options={})
          
          Connector.wiki_options = options
          
          if location.is_a?(::String)
            con = location
          else
            con = location.path
          end
          
          Connector.wiki_path = con
          
        end
      
        # Static call from within any other class
        #
        # Returns a new instance of this class
        def self.wiki(location, options={})
          Wiki.new(location, options)
        end

        # Forwards unknown methods to Gollum::Wiki
        #
        # may throw an Argument error or method missing
        def self.method_missing(name, *args)
          Connector.wiki_class.send(name, *args)
        end

      end
    end
  end
end
