require 'active_model'
module GollumRails

  # Adapter class. To be documented
  module Adapters
    # ActiveModel improvements and own connectors
    #
    # including:
    #   * validation
    #   * callbacks
    #   * naming
    #   * error handling
    # 
    # The following files are involved:
    #   * boolean.rb -> Boolean features for validation
    #   * naming.rb -> Conversion and Naming
    #   * error.rb -> Active Model error handling
    #
    # Released under the AGPL License. For further information see the LICENSE file distributed
    # with this package.
    #
    # TODO:
    #   * a lot of testing
    #
    #
    module ActiveModel

      # connector version
      VERSION="1.21.0"
    end
  end
end

require File.expand_path '../activemodel/boolean', __FILE__
require File.expand_path '../activemodel/naming', __FILE__
require File.expand_path '../activemodel/error', __FILE__
