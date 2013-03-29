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
    #   * callback.rb -> Callback functionality
    #   * naming.rb -> Conversion and Naming
    #   * error.rb -> Active Model error handling
    #   * validation.rb -> Object validation
    #
    # Released under the AGPL License. For further information see the LICENSE file distributed
    # with this package.
    #
    # TODO:
    #   * a lot of testing
    #   * implementing the rest of the error class
    #   * deleting the model template out
    #   * move into own gem
    #
    # FIXME:
    #   none a.t.m.
    #
    module ActiveModel

      # connector version
      VERSION="0.0.4"
    end
  end
end

require File.expand_path '../activemodel/boolean', __FILE__
require File.expand_path '../activemodel/callback', __FILE__
require File.expand_path '../activemodel/naming', __FILE__
require File.expand_path '../activemodel/error', __FILE__
require File.expand_path '../activemodel/validation', __FILE__
