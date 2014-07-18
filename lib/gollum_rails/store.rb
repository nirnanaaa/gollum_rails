module GollumRails
  module Store
    extend ActiveSupport::Concern

    module ClassMethods
      # Gets the wiki instance
      def wiki
        raise InitializationError, "Wiki path was not initialized!" if Setup.wiki_path.nil?
        raise InitializationError, "Options are invalid. Please consult the manual." unless Setup.wiki_options.kind_of? Hash
        @wiki = Gollum::Wiki.new(Setup.wiki_path, Setup.wiki_options)
      end
    end

    private
    # == To static
    def wiki
      self.class.wiki
    end



  end
end
