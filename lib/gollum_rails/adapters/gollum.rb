# ~*~ encoding: utf-8 ~*~
module GollumRails
  module Adapters
    # Gollum Wiki connector classes
    #
    # TODO:
    #   * implement
    #
    # FIXME:
    #   currently nothing implemented
    #
    module Gollum
      # connector version
      VERSION="0.0.0"
      class Connector
        class << self
          # Sets the page class used by all instances
          attr_writer :page_class

          # Sets the wiki class used by all instances
          attr_writer :wiki_class

          # Sets the committer
          attr_writer :committer_class

          # Gets the Globally used Page class or use a new one if not defined
          #
          #
          # Returns the internal page class or a fresh ::Gollum::Page
          def page_class
            @page_class || Page
          end

          # Gets the Globally used Page class or use a new one if not defined
          #
          #
          # Returns the internal page class or a fresh ::Gollum::Page
          def wiki_class
            @wiki_class || Wiki
          end

          # Gets the current committer or using anon
          #
          #
          def committer_class
            @committer_class || Committer
          end
        end
      end
    end
  end
end

require File.expand_path '../gollum/wiki', __FILE__
require File.expand_path '../gollum/committer', __FILE__
require File.expand_path '../gollum/page', __FILE__
