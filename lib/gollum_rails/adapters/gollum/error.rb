module GollumRails
  module Adapters
    module Gollum

      # Gollum adapter Error handling class
      #
      # provides better errors
      class Error < ::StandardError

        # does the formatting of the Error message
        #
        #
        def initialize(error_message, urgence)
          super "#{urgence.upcase} :: #{error_message}"
        end
      end
    end
  end
end
