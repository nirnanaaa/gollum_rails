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
        def initialize(name, message = "", stack = nil, priority = :low)
          @errors = ActiveModel::Errors.new(self)
          if priority == :high or priority == :crit
            raise self, "Error thrown: #{name},\n #{(stack || message)}"
          else
            errors.add priority.to_sym
          end

        end


      end

    end
  end
end
