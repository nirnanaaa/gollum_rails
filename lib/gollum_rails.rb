require 'rubygems'
require 'gollum'

module Gollum
  module Rails
    require 'gollum/rails/engine' if defined?(Rails)
  end
end

require 'gollum/rails/gollum_rails' if defined?(Rails)