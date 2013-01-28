require 'yaml'

module GollumRails
    class Config
      attr_reader :config
      def self.read_config
        config = self.open_config
        DependencyInjector.set({:config => config})
      end
      def self.read_rails_conf(app)
        DependencyInjector.set({:rails_conf => self.open_gollum_rails_conf(app)})
      end
      def self.config_location
      end

      def self.lang_from_rails
      end

      def self.settings_from_rails
        Rails.settings
      end

      def self.rails_root
        Rails.root
      end

      def self.rails_config_dir
      end
      
      #######
      private
      #######
      #gives a hardcoded configuration file
      def self.open_config
        YAML.load_file(::File.join(::File.dirname(__FILE__), 'messages.yml'))
      end
      def self.open_gollum_rails_conf(app)
        YAML.load_file(app.root.join("config", "gollum.yml"))
      end

    end
end