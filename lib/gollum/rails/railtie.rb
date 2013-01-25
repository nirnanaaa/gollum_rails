module Gollum
  module Rails
    class Engine < Rails::Engine
      initialize "my_engine.load_app_root" do |app|
         Gollum::Rails::Config::app_root = app.root
      end
    end
  end
end

