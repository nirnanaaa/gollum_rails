module GollumRails
  module Attributes
    extend ActiveSupport::Concern

    # Allows you to set all the attributes by passing in a hash of attributes with
    # keys matching the attribute name
    #
    # new_attributes - Hash - Hash of arguments
    def assign_attributes(new_attributes)
      if !new_attributes.respond_to?(:stringify_keys)
        raise ArgumentError, "When assigning attributes, you must pass a hash as an argument."
      end
      return if new_attributes.blank?
      attributes = new_attributes.stringify_keys
      attributes.each do |k, v|
        _assign_attribute(k, v)
      end
    end

    private

    def _assign_attribute(key, value)
      public_send("#{key}=", value)
    rescue NoMethodError
      if respond_to?("#{key}=")
        raise
      end
    end



  end
end
