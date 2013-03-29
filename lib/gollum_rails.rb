require 'rubygems'
require 'gollum-lib'

# GollumRails is a RubyGem for extending Rails and the Gollum wiki powered by github
# It has the ability to combine the benefits from a git powered wiki with Rails.
#
# Example solutions:
#   * Gollum Wiki pages - Devise authentication - GollumRails connector - Haml layouting
#   * Gollum Wiki pages - Ember.js - Handlebars layout - Rails REST API
#   * ...
#
module GollumRails
  
  # GollumRails version string
  VERSION="0.0.3"
  
  # Simplified error
  class Error < StandardError; end

  # For use with internal gollumGem exceptions
  # 
  class GollumInternalError < Error
  
  end
end


require File.expand_path '../gollum_rails/adapters/activemodel', __FILE__
require File.expand_path '../gollum_rails/adapters/gollum', __FILE__
require File.expand_path '../gollum_rails/setup', __FILE__
# load extensions
require File.expand_path '../gollum_rails/modules/loader', __FILE__


