require 'rails/generators'

module GollumRails

  # Generators for GollumRails
  module Generators

    # Generates models
    class ModelGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator will create a model"
      argument :model_name, :type => :string

      # generates a model
      def create_model
        if ::File.exist? Rails.root.join("app", "models", "#{file_name}")
          raw = <<-EOM
          Warning: The file already exists
          EOM
          red raw
        else
          template "model_template.erb", "app/models/#{file_name}.rb"
        end
      end

      private

      # Gets the filename
      def file_name
        model_name.underscore
      end

      # Gets the classname
      def class_name
        model_name.camelize
      end

      # colorizes
      def colorize(text, color_code)
        "#{color_code}#{text}e[0m"
      end

      # colorizes red
      def red(text); colorize(text, "e[31m"); end

      # colorizes green
      def green(text); colorize(text, "e[32m"); end
    end
  end
end

