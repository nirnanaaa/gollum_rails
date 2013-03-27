# ~*~ encoding: utf-8 ~*~

# externals
require 'rubygems'
require 'gollum'

# internals
#require File.expand_path('../gollum_rails/engine', __FILE__)
#require File.expand_path('../gollum_rails/dependency_injector', __FILE__)
#require File.expand_path('../gollum_rails/config', __FILE__)
#require File.expand_path('../gollum_rails/wiki', __FILE__)
#require File.expand_path('../gollum_rails/validations', __FILE__)
#require File.expand_path('../gollum_rails/file', __FILE__)
#require File.expand_path('../gollum_rails/page', __FILE__)

# gollum still supports ruby 1.8.7 so gollum_rails must also do
#
$KCODE = 'U' if RUBY_VERSION[0,3] == '1.8'

# Public: Main application class
#
module GollumRails

  # Public: Gets the applications version
  VERSION = '0.0.3'

end
