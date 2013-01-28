require 'rails'

module GollumRails
  class Engine < ::Rails::Engine
    initializer "gollum_rails.load_app",
    :group => :all do |app|

      if is_installed? app
        DependencyInjector.set({:installed => true})
        Config.read_rails_conf(app)
        Config.read_config
        config = DependencyInjector.rails_conf
        if config[:location_type] == "relative"
          path = app.root.join(config[:location])
        elsif config[:location_type] == "absolute"
          path = config[:location]
        end
        Wiki.new(path)
      end
    end

    def is_installed?(app)
      return ::File.exist?(app.root.join("config", "gollum.yml"))
    end
  end

end

