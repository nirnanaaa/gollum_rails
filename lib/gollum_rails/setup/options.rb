module GollumRails
  module Setup
    module Options
      extend ActiveSupport::Concern

      module ClassMethods
        attr_accessor :wiki_options
        attr_accessor :repository
        attr_accessor :startup
        attr_accessor :options
        attr_accessor :wiki_path
      end

    end
  end
end
