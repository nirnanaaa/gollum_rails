module GollumRails
  module Adapters
    module ActiveModel
      class Error < ::GollumRails::GollumInternalError
        extend ::ActiveModel::Naming
        
        private
        
        attr_reader :priority

        public
        # Gets/Sets the Error
        attr_reader :errors

        # Initializes a new Instance of ActiveModel
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
