require 'rails/generators'

module GollumRails
  module Generators
    class ModelGenerator < ::Rails::Generators::Base
      desc "Install a new model into app/models"
      argument :model_name, :type => :string
      
      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end
      
      def write_class
        puts class_name
      end
      
      protected
      
      def class_name
        model_name.camelize
      end
    end
  end
end