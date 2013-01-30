require 'rails/generators'

module GollumRails
  # Public: Rails Generator
  module Generators
    # Public: rails g gollum_rails:install
    #
    class InstallGenerator < ::Rails::Generators::Base
      desc "Installs the RailsGollum files"
      source_root ::File.expand_path("../templates", __FILE__)

      class_option :messages, :type => :boolean, :default => true, :description => "Include error message templates"
      # Public: copyies the configuration fiile
      def copy_config
        copy_file "gollum.yml", Rails.root.join("config", "gollum.yml")
        copy_file "messages.yml", Rails.root.join("config", "locales", "gollum.#{default_locale}.yml") if options.messages?
      end

      # Public: gets rails default locale
      #
      # Returns a String
      def default_locale
        locale = Rails.configuration.i18n.default_locale
        return locale if locale
        return "en"
      end
    end
  end
end