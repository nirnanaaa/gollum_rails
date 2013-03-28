module GollumRails
  module Adapters
    module ActiveModel
      class Error < ::GollumRails::GollumInternalError
        extend Naming::
        
        # Gets/Sets the Error
        attr_accessor :errors

        # Initializes a new Instance of ActiveModel
        # 
        def initialize
          @errors = ActiveModel::Errors.new(self)
        end
      end

    end
  end
end
