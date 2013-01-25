module Gollum
  module Rails
    class Wiki
      attr_accessor :wiki
      def initialize(path)
        send("wiki=", getMainGollum(path))
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
    end
  end
end