module GollumRails
    class Wiki
      attr_accessor :wiki
      def initialize(path)
        main = getMainGollum(path)
        send("wiki=", main)
        DependencyInjector.set({:wiki => self})
      end

      def getMainGollum(path)
        wiki = Gollum::Wiki.new(path)
      end

      def getPath
        @wiki.path
      end

      def getRepo
        @wiki.repo
      end

      def search(string = '')

      end
      
      ## static setters / getters
      
      def self.getWiki
        @wiki
      end
    end
  end