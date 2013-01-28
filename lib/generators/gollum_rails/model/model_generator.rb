require 'rails/generators'

module GollumRails
  module Generators
    class ModelGenerator < ::Rails::Generators::Base
      desc "Install a new model into app/models"
      argument :model_name, :type => :string
    end
  end
end