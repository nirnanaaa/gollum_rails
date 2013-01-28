require 'rails'

module GollumRails
  class Engine < ::Rails::Engine
    initializer "gollum_rails.load_app" do |app|
      #super
      ##   GollumRails::Config::rails = app
    end
  end

end

