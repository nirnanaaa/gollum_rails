require 'yaml'

module GollumRails

  # Public: GollumRails::Config
    class Config

      # Public: Gets/Sets the configuration (DEPRECATED will be removed in 0.0.4)
      attr_reader :config

      # Public: Gets/Pushes the internal configuration
      #
      # Returns the hashed configuration
      def self.read_config
        config = self.open_config
        DependencyInjector.set({:config => config})
      end

      # Public: Gets/Pushes the RAILS internal configuration
      #
      # Returns the hashed configuration
      def self.read_rails_conf
        app = DependencyInjector.app
        DependencyInjector.set({:rails_conf => self.open_gollum_rails_conf(
        DependencyInjector.app
        )})
      end

      # Public: Gets the internals config location
      #
      # Returns a String => path
      def self.config_location
      end

      # Public: Gets the current language from RailsENV
      #
      def self.lang_from_rails
      end

      # Public: Gets the app configuration
      #
      def self.settings_from_rails
        DependencyInjector.app.settings
      end

      # Public: Gets  the rails root path
      #
      # Returns a string
      def self.rails_root
        DependencyInjector.app.root
      end

      # Public: Gets the path of the rails config dir
      def self.rails_config_dir
      end

      #######
      private
      #######

      # Public: opens hardcoded configuration file
      #
      def self.open_config
        YAML.load_file(::File.join(::File.dirname(__FILE__), 'messages.yml'))
      end

      # Public: opens the hardcoded rails conf
      #
      def self.open_gollum_rails_conf(app)
        YAML.load_file(app.root.join("config", "gollum.yml"))
      end

    end
end
