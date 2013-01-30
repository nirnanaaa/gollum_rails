module GollumRails
  # Public: Should perform ActiveModel validations
  class Validations
    
    # Public: checks if variable is boolean
    #
    # variable - some mixed data
    #
    # Returns either true or false
    def self.is_boolean?(variable)
      variable.is_a?(TrueClass) || variable.is_a?(FalseClass)
    end

  end
end