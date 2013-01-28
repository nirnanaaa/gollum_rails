# ~*~ encoding: utf-8 ~*~

# externals
require 'rubygems'
require 'gollum'

# internals
require File.expand_path('../gollum_rails/engine', __FILE__)
require File.expand_path('../gollum_rails/dependency_injector', __FILE__)
require File.expand_path('../gollum_rails/config', __FILE__)
require File.expand_path('../gollum_rails/wiki', __FILE__)

$KCODE = 'U' if RUBY_VERSION[0,3] == '1.8'

module GollumRails

  VERSION = '0.0.2.7'

end
