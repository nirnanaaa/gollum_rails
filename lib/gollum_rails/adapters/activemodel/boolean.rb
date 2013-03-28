module GollumRails
  module Adapters
    module ActiveModel

      # Own implemented Boolean method for validating
      module Boolean; end

      # inherit
      class ::TrueClass; include Boolean; end

      # inherit
      class ::FalseClass; include Boolean; end
    end
  end
end
