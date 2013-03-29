
module GollumRails
  module Adapters
    module ActiveModel

      # Naming class for all Classes, extending the AdtiveModel::Naming module
      #
      # provides base functionality like filenames, classnames, variable-, instancenames
      module Naming
        
        # Outputs the currents class name
        #
        # Returns a String
        def class_name
          self.class.name
        end

        # Gets the pluralized filename for an object
        #
        # Returns a String
        def plural_filename_for_class(name)
         return ::ActiveModel::Naming.plural name if name.model_name
         return nil
        end

        # Gets the singularized filename for an object
        #
        # Returns a String
        def singular_filename_for_class(name)
         return ::ActiveModel::Naming.singular name if name.model_name
         return nil
        end
      
        # dummy namespace class
        class NameSpace
          extend ::ActiveModel::Naming
        end
      end

    end
  end
end
