module GollumRails
  module Adapters
    module ActiveModel

      # General Validation Class including validations
      class Validation
        include ::ActiveModel::Validations
        
        #########
        protected
        #########

        # Sets the variable, used to validate
        attr_writer :variable
        
        # Sets the Filter
        attr_accessor :filter

        # Sets all instance errors to this variable
        attr_writer :error

        ######
        public
        ######
        
        # Gets the variable, used to validate
        attr_reader :variable

        # Gets the error messages
        attr_reader :error

        # Checks for errors and returns either true or false
        #
        # Examples:
        #   @validator.valid?
        #   # => true
        #   or 
        #   # => false
        #
        def valid?(errors = {})
          super
          return true if self.errors.messages == Hash.new and errors == Hash.new
          self.error = errors
          return false
        end

        # Initializes the Validator
        # You can pass in a block with validators, which will be used to validate given attributes
        # 
        # Blocks look like:
        #
        # "#{variable} : type=String : max=200"
        # "#{textvariable} : type=Hash"
        # "#{integer} : min=100 : max=200"
        #
        # They have always the following format:
        #   
        #   KEY=VALUE or KEY!VALUE
        #
        #   key=value explains itself. It validates the variable <b>variable</b> with the given <b>key<b> validator
        #   and checks if it matches the given <b>value</b>
        #
        #   key!value is the negociation of key=value
        #
        #
        # The following keys are currently available:
        #   * type
        #   * max
        #   * present
        #   * min
        #
        # Following:
        #   * contribute yourself
        #
        # Usage:
        #   variable = "This is a simple test"
        #   validator = GollumRails::Adapters::ActiveModel::Validation.new 
        #   validator.validate!  do |a|
        #     a.validate(variable, "type=String,max=100,present=true")
        #   end 
        #   validator.valid?
        #   # => true
        #
        # Params:
        #   block - Block to use
        #
        # Returns:
        def validate(&block)
          bla = block.call(self)
        end
        

        # Aliasing test method
        alias_method :validate!, :test

        # Tests given variable for conditions
        #
        # Params:
        #   variable - variable to validate
        #   statement - validation statement, seperated by coma
        #
        #
        def test(variable,statement)
          validation = {}
          if statement.include? ',' and statement.include? '='
            statement.split(',').each{|equalized|
             key,value = split_equalized_string equalized
             validation[key.to_s.downcase.to_sym] = value if not key.nil?
            }
          elsif statement.include? '='
            key,value = split_equalized_string statement
            validation[key.to_s.downcase.to_sym] = value if not key.nil? 
          else
            raise Error, 'Syntax error! '
          end
          self.instance_variable_set("@variable", variable)

          validation.each_with_index do |k|
            if k.first.to_s.match /^type$/i
              code = <<-END
                self.singleton_class.class_exec do attr_accessor :type end
                self.instance_variable_set("@type", "#{k[1]}")
                validates_with ValidateType, :fields => [:variable]
              END
            elsif k.first.to_s.match /^(present|presence|pres)$/i
              code = <<-END
                validates_presence_of :variable
              END
            elsif k.first.to_s.match /^(min|max)$/i
              code = <<-END
                validates_length_of :variable, :#{k.first.to_s}imum => #{k[1].to_i}
              END
            elsif k.first.to_s.match /^blank$/i
              code = <<-END
                validates_length_of :variable, :allow_blank #{k[1]}
              END
            else
              puts <<-END
              WARNING: no validator matches! This will cause an Error in the next release
              END
              next
            end
            self.instance_eval(code) if code
          end
          errors = self.errors.messages
          self.errors.instance_variable_set("@messages", {})
          valid? errors
        end
  
        #######
        private
        #######
        
        # Splits given by "="
        #
        # string - String to be split
        #
        # Returns splitted string or raise an error
        def split_equalized_string(string)
          if string.match /\w+\=(\w+|\d+)/i
            return string.split(/\=/,2)
          else
            raise Error, <<-END 
              Syntax error in given String #{string}. Equal sign is missing
            END
          end

        end
      end


      # Validation helper for type:
      #
      # <b>Type</b>
      class ValidateType < ::ActiveModel::Validator

        # Validate given Data with given validation object
        #
        # sets error or returns true
        def validate(record)
          if record.type.match(/^\w+$/i)
            name = eval "#{record.type.to_s}"
            return true if record.variable.is_a? name
            record.errors.add :type, "not a kind of given class #{record.type}"
          else
            record.errors.add :type ,"invalid input detected"
          end
        end
      end
    end
  end
end
