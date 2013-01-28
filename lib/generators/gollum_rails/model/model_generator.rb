require 'rails/generators'

module GollumRails
  module Generators
    class ModelGenerator < ::Rails::Generators::Base
      desc "Install a new model into app/models"
      source_root ::File.expand_path("../templates", __FILE__)
      argument :model_name, :type => :string
      
      def write_class
        if ::File.exist? Rails.root.join("app", "models", "#{file_name}")
          puts <<-EOM
          Warning: The file already exists
          EOM
        else
          template "model.rb.erb", Rails.root.join("app", "models", "#{file_name}")
        end
      end
      
      protected
      
      def class_name
        model_name.camelize
      end
      def file_name
        "#{model_name.downcase.underscore}.rb"
      end
      
    end
  end
end