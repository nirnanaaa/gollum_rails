require 'yaml'

module Gollum
  module Rails
    class Config
      attr_reader :config
      def self.read_config
        @config = self.open_config
        @config
      end
      def self.config_location
      end

      def self.lang_from_rails
      end

      def self.settings_from_rails
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

    end
  end
end