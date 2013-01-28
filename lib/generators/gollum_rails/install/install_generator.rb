require 'rails/generators'

module GollumRails
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Installs the RailsGollum files"
      source_root ::File.expand_path("../templates", __FILE__)
      
      class_option :messages, :type => :boolean, :default => false, :description => "Include error message templates"
      
      def copy_config
        copy_file "gollum.yml", Rails.root.join("config", "gollum.yml")
        copy_file "messages.yml", Rails.root.join("config", "locales", "gollum.#{default_locale}.yml") if options.messages?
      end
      def default_locale
        Rails.configuration.i18n.default_locale
      end
    end
  end
end