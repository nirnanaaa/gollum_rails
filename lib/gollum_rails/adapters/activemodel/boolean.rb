module GollumRails
  module Adapters
    module ActiveModel
      module Boolean; end
      class ::TrueClass; include Boolean; end
      class ::FalseClass; include Boolean; end
    end
  end
end
