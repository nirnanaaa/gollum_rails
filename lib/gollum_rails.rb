# ~*~ encoding: utf-8 ~*~

# stdlib
require 'rubygems'

# external
require 'gollum-lib'

# patches
require 'grit/git-ruby/internal/pack'
require 'core_ext/string'

# GollumRails is a RubyGem for extending Rails and the Gollum wiki powered by github
# It has the ability to combine the benefits from a git powered wiki with Rails.
#
# Example solutions:
#   * Gollum Wiki pages - Devise authentication - GollumRails connector - Haml layouting
#   * Gollum Wiki pages - Ember.js - Handlebars layout - Rails REST API
#   * ...
#
module GollumRails
  autoload :Page,     'gollum_rails/page'
  autoload :Setup,    'gollum_rails/setup'

  # GollumRails version string
  VERSION = '1.4.1'

  # Simplified error
  class Error < StandardError; end

  # All Gollum internal exceptions will be redirected to this
  class GollumInternalError < Error


    attr_accessor :name
    attr_accessor :message
    attr_accessor :target

    # modifies content for throwing an exception
    def initialize(name, target = nil, message = nil)
      @name = name
      @target = target
      @message = message

      super(message || "An Error occured: #{name} on #{target}")
    end

    # Fancy inspects
    def inspect
      "#<GollumRails::GollumInternalError:#{object_id} {name: #{name.inspect}, message: #{message.inspect}, target: #{target.inspect}}>"      
    end
  end
end


require File.expand_path '../gollum_rails/adapters/activemodel', __FILE__
require File.expand_path '../gollum_rails/adapters/gollum', __FILE__
