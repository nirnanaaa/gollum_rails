require 'active_model'

module GollumRails
  module Adapters
    module ActiveModel
      class Callback
        extend ::ActiveModel::Callbacks
        
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
