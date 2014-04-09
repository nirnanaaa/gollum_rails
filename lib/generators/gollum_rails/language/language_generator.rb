require 'rails/generators'

module GollumRails

  # Generators for GollumRails
  module Generators

    # Generates additional language files
    class LanguageGenerator < ::Rails::Generators::Base
      desc "This generator will install gollum_rails"
      
      argument :language, :type => :string

      # installs languages
      def install_languages
        case language
        when "ascii"
          puts <<-EOT
          \n Installation instructures for ASCIIDoc:\n
          \n\n Ubuntu/Debian Linux:
          \n (sudo) apt-get install asciidoc
          \n\n Mac with homebrew:
          \n brew install asciidoc 
          \n
          EOT
        when "markdown"
          run "gem install redcarpet"
          puts <<-EOT
          \n Parser for type "markdown" was installed
          \n
          EOT
        when "better-markdown"
          run "gem install github-markdown"
          puts <<-EOT
          \n Parser for type "github-markdown" was installed
          \n
          EOT
        when "textile"
          run "gem install RedCloth"
          puts <<-EOT
          \n Parser for type "textile" was installed
          \n
          EOT
        when "wiki"
          run "gem install wikicloth"
          puts <<-EOT
          \n Parser for type "wiki" was installed
          \n
          EOT
        when "org"
          run "gem install org-ruby"
          puts <<-EOT
          \n Parser for type "org-ruby" was installed
          \n
          EOT
        when "creole"
          run "gem install creole"
          puts <<-EOT
          \n Parser for type "creole" was installed
          \n
          EOT
        when "pod"
          puts <<-EOT
          \nPOT must be installed through CPAN (perl)
          \nSee http://search.cpan.org/dist/perl/pod/perlpod.pod for further information
          \n
          EOT
        when "rst"
          puts <<-EOT
          \nInstall through 'easy_install'
          \nSee http://docutils.sourceforge.net/rst.html for further information
          EOT
        else
          puts "UNKNOWN LANGUAGE"
          exit 1
        end
      end
    end
  end
end

