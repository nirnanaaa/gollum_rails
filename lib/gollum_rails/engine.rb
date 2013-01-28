require 'rails'

module GollumRails
  class Engine < ::Rails::Engine
    initializer "gollum_rails.load_app",
                :group => :all do |app|
                  
      if is_installed? app
        DependencyInjector.set({:installed => true})
        Config.read_rails_conf(app)
      end
    end
    def is_installed?(app)
      return ::File.exist?(app.root.join("config", "gollum.yml"))
    end
  end

end

 