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

      end
    end
  end
end
