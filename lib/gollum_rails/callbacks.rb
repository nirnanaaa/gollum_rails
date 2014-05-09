module GollumRails
  module Callbacks
    extend ActiveSupport::Concern

    CALLBACKS = [
      :after_initialize,
      :before_save, :around_save, :after_save, :before_create, :around_create,
      :after_create, :before_update, :around_update, :after_update,
      :before_destroy, :around_destroy, :after_destroy, :after_commit
    ]

    module ClassMethods
      include ActiveModel::Callbacks
    end

    included do
      include ActiveModel::Validations::Callbacks
      define_model_callbacks :initialize, :only => :after
      define_model_callbacks :save, :create, :update, :destroy
    end

    def destroy(*) #:nodoc:
      run_callbacks(:destroy) { super }
    end

    def save #:nodoc:
      run_callbacks(:save) { super }
    end

    private

    def create_or_update #:nodoc:
     run_callbacks(:save) { super }
    end

    def create_record #:nodoc:
     run_callbacks(:create) { super }
    end

    def update_record(*) #:nodoc:
     run_callbacks(:update) { super }
    end

  end
end
