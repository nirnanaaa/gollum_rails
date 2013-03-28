module GollumRails
  module Adapters
    module ActiveModel

      # Error handling class, with several exception types and debug / info messages
      class Error < ::GollumRails::GollumInternalError
        extend ::ActiveModel::Naming
        
        #######
        private
        #######

        # Gets the Priority
        attr_reader :priority

        ######
        public
        ######

        # Gets/Sets the Error
        attr_reader :errors

        # Initializes a new Exception
        # 
        def initialize(name, message = nil, stack = nil, priority = :crit)
          if priority == :high or priority == :crit
            super("Error thrown: #{name},\n\n #{(message||stack)}")
          else
            puts "Info: #{name}, \n\n #{(message||stack)}"
          end
        end


      end

    end
  end
end
