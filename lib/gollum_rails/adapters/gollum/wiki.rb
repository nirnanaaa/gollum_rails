require 'grit'
module GollumRails
  module Adapters
    module Gollum

      # TODO: doc
      class  Wiki

        # Gets / Sets the git path or object
        attr_accessor :git

        # Initializes the class
        #
        # location - String or Grit::Repo
        def initialize(location, options=nil)
          @git = location
          if location.is_a? ::String
            con = ::Gollum::Wiki.new(@git, options)
          else
            con= ::Gollum::Wiki.new(@git.path, options)
          end
          Connector.wiki_class = con
        end
      
        # Static call from within any other class
        #
        # Returns a new instance of this class
        def self.wiki(location, options=nil)
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
