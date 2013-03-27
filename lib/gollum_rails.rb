require 'rubygems'
require 'gollum-lib'


require File.expand_path '../gollum_rails/adapters/activemodel', __FILE__
require File.expand_path '../gollum_rails/adapters/gollum', __FILE__
require File.expand_path '../gollum_rails/repository', __FILE__
require File.expand_path '../gollum_rails/page', __FILE__

# load extensions
require File.expand_path '../gollum_rails/modules/loader', __FILE__


module GollumRails
  
  VERSION="0.0.3"
  
  class Error < StandardError; end
  class GollumInternalError < Error
  
  end
end



