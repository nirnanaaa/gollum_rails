require 'rails/generators'

module GollumRails

  # Generators for GollumRails
  module Generators

    # Installation generator
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "This generator will install gollum_rails"

      # Installs the necessary files
      def install_application
        if File.exist? 'config/initializers/gollum.rb'
          puts <<-EOM
            Warning! 'config/initializers/gollum.rb' exists
            It should be removed, as it may contain data of a previous installation
          EOM
        else
          copy_file "gollum_initializer.rb", "config/initializers/gollum.rb"
        end
      end
    end
  end
end

