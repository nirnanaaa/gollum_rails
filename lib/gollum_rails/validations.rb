## Overrides

module GollumRails
    class Validations 
      def self.is_boolean?(variable)
        variable.is_a?(TrueClass) || variable.is_a?(FalseClass)
      end

    end
  end