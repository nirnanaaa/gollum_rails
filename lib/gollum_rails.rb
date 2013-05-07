require 'rubygems'
require 'gollum-lib'
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
  VERSION = '1.4.0'

  # Simplified error
  class Error < StandardError; end

  # For use with internal gollumGem exceptions
  #
  class GollumInternalError < Error

  end
end


require File.expand_path '../gollum_rails/adapters/activemodel', __FILE__
require File.expand_path '../gollum_rails/adapters/gollum', __FILE__
# load extensions
# TODO: Remove this shit. It is unnecessary
require File.expand_path '../gollum_rails/modules/loader', __FILE__
