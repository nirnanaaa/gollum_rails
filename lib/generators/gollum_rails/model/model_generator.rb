require 'rails/generators'

module GollumRails
  # Public: Rails Generator
  module Generators
    
    # Public: rails g gollum_rails:model <MODEL_NAME>
    #
    class ModelGenerator < ::Rails::Generators::Base
      desc "Install a new model into app/models"
      source_root ::File.expand_path("../templates", __FILE__)
      argument :model_name, :type => :string
      
      # Public: writes model file
      #
      def write_class
        if ::File.exist? Rails.root.join("app", "models", "#{file_name}")
          raw = <<-EOM
          Warning: The file already exists
          EOM
          green raw
        else
          template "model.rb.erb", Rails.root.join("app", "models", "#{file_name}")
        end
      end
      
      protected
      
      # Public: gets the models classname
      def class_name
        model_name.camelize
      end
      
      # Public: gets model name (downcased, trimed, underscored)
      def file_name
        "#{model_name.downcase.strip.underscore}.rb"
      end
      
      private
      
      # Public: colorite text with color code
      def colorize(text, color_code)
        "#{color_code}#{text}e[0m"
      end
      
      # Public: red colored output
      def red(text); colorize(text, "e[31m"); end
        
      # Public: green colored output
      def green(text); colorize(text, "e[32m"); end
        
    end
  end
end