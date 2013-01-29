require 'rails'
module GollumRails
  class Engine < ::Rails::Engine
    initializer "gollum_rails.load_app",
    :group => :all do |app|

      if is_installed? app
        DependencyInjector.set({:in_rails => true, :app => app})

        # Env could be:
        # - rails
        # - standalone ( wont get here )
        # - sinatra ( not supported yet )
        #
        if Wiki.is_a? Class
          wiki = Wiki.new( nil, { :env => :rails } )
        end
        #Config.read_rails_conf
        #::File.write("./wiki", DependencyInjector.rails_conf.location)
        wiki

      end
    end

    private

    def is_installed?(app)
      return ::File.exist?(app.root.join("config", "gollum.yml"))
    end
  end

end

