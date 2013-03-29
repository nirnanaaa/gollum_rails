module GollumRails
  module Adapters
    module ActiveModel

      # Error handling class, with several exception types and debug / info messages
      class Error < ::GollumRails::GollumInternalError
        extend ::ActiveModel::Naming
        
        ######
        public
        ######

        # Gets/Sets the Error
        attr_reader :errors

        # Initializes a new Exception
        # 
        def initialize(name, message = nil, priority = :crit)
          super("Error thrown: #{name},\n\n #{(message)}")
        end


      end

    end
  end
end
