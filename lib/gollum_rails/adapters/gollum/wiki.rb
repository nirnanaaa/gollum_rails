require 'grit'
module GollumRails
  module Adapters
    module Gollum

      # TODO: doc
      class  Wiki

        # Gets / Sets the git path or object
        attr_accessor :git
        
        # Gets / Sets the wiki instance
        attr_accessor :wiki

        def initialize(location)
          gollum = ::Gollum::Wiki
          @git = location
          if location.is_a? ::String
            @wiki = gollum.new @git
          else
            @wiki = gollum.new @git.path
          end
        end

        def self.wiki(location)
          Wiki.new(location)
        end

      end
    end
  end
end
