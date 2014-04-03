module GollumRails
  module Setup
    module Options
      extend ActiveSupport::Concern

      module ClassMethods

        # == Reads out the wiki options. Important is, that there needs to be some kind of hash to be present.
        #
        #
        def wiki_options
          @wiki_options ||= {}
          return @wiki_options if @wiki_options.kind_of? Hash
          raise InitializationError, "Options must be a kind of Hash. Found: #{@wiki_options.class}"
        end

        attr_writer :wiki_options

        attr_accessor :repository
        attr_accessor :startup
        attr_accessor :options
        attr_accessor :wiki_path
      end

    end
  end
end
