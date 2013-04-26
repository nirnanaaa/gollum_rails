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
      autoload :Wiki,       'gollum_rails/adapters/gollum/wiki'
      autoload :Page,       'gollum_rails/adapters/gollum/page'
      autoload :Error,      'gollum_rails/adapters/gollum/error'

      # connector version
      VERSION="2.0.0"

      # Gollum connector class, keeping defaults!
      #
      class Connector
        class << self
          # Sets the page class used by all instances
          attr_writer :page_class

          # Sets the wiki class used by all instances
          attr_writer :wiki_class

          # Sets the committer
          attr_writer :committer_class

          # Sets the applications status
          attr_writer :enabled

          # Gets the enabled status
          #
          # Returns a boolean value
          def enabled
            @enabled || false
          end
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
