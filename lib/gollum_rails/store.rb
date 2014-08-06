module GollumRails
  module Store
    extend ActiveSupport::Concern

    module ClassMethods
      # Gets the wiki instance
      def wiki
        raise InitializationError, "Wiki path was not initialized!" if Setup.wiki_path.nil?
        raise InitializationError, "Options are invalid. Please consult the manual." unless Setup.wiki_options.kind_of? Hash
        @wiki = Gollum::Wiki.new(Setup.wiki_path, Setup.wiki_options)
        Setup.filters.each do |filter|
          @wiki.add_filter(*filter)
        end
        @wiki
      end
    end

    def setup_branches
      repo = wiki.repo
      raise
    end
    # == To static
    def wiki
      self.class.wiki
    end



  end
end
