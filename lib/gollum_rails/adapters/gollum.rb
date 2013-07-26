# ~*~ encoding: utf-8 ~*~
module GollumRails
  module Adapters
    # Gollum Wiki connector classes
    #
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
          attr_writer :wiki_path
          
          # Sets the wiki options
          attr_writer :wiki_options
          

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
          
          # Gets the wiki options
          def wiki_options
            @wiki_options || {}
          end

          # Gets the Globally used Page class or use a new one if not defined
          #
          #
          # Returns the internal page class or a fresh ::Gollum::Page
          def wiki_path
            @wiki_class || Wiki
          end

        end
      end
    end
  end
end
