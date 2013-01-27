require 'rubygems'
require 'gollum'



module Gollum
  module Rails
  VERSION = '0.0.2.4'
    require 'gollum_rails/engine' if defined?(Rails)
  end
end

require 'gollum_rails/gollum_rails' if defined?(Rails)