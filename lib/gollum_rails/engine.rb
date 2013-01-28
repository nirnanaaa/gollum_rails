require 'rails'

module GollumRails
  class Engine < ::Rails::Engine
    initializer "gollum_rails.load_app",
                :group => :all do |app|
      puts ::File.exist?(app.root.join("config", "gollum.yml"))
    end
    def is_installed?
      true
    end
  end

end

 