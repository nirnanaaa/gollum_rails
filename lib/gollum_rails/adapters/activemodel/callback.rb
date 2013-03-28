require 'active_model'

module GollumRails
  module Adapters
    module ActiveModel
      
      # Callback handling class
      class Callback
        extend ::ActiveModel::Callbacks
        
        define_model_callbacks :create, :only => [:after, :before]
        define_model_callbacks :update, :only => [:after, :before]
        define_model_callbacks :save, :only => [:after, :before]
        define_model_callbacks :delete, :only => [:after, :before]
        define_model_callbacks :find, :only => [:after, :before]

        before_create :before_create
        before_update :before_update
        before_save :before_save
        before_delete :before_delete
        before_find :before_find

        after_create :after_create
        after_update :after_update
        after_save :after_save
        after_delete :after_delete
        after_find :after_find

        # Before create action
        def before_create; end
        
        # Before update action
        def before_update; end

        # Before save action
        def before_save; end

        # Before delete action
        def before_delete; end

        # Before find action
        def before_find; end

        # After create action
        def after_create; end

        # After update action
        def after_update; end

        # After save action
        def after_save; end

        # After delete action
        def after_delete; end

        # After find action
        def after_find; end

      end

    end
  end
end
