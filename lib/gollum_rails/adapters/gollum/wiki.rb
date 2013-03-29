require 'grit'
module GollumRails
  module Adapters
    module Gollum

      # TODO: doc
      class  Wiki

        # Gets / Sets the git path or object
        attr_accessor :git

        # Static callers
        class << self
          # Gets / Sets the wiki instance
          attr_accessor :wiki
        end

        # Initializes the class
        #
        # location - String or Grit::Repo
        def initialize(location)
          gollum = ::Gollum::Wiki
          @git = location
          if location.is_a? ::String
            @@wiki = gollum.new @git
          else
            @@wiki = gollum.new @git.path
          end
        end
      
        # Static call from within any other class
        #
        # Returns a new instance of this class
        def self.wiki(location)
          Wiki.new(location)
        end

      end
    end
  end
end
