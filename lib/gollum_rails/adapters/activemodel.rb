require 'activemodel'

module GollumRails
  module Adapters
    include ::ActiveModel::Validations
    include ::ActiveModel::Conversion
    extend ::ActiveModel::Naming
    
  end
end
