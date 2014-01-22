# ~*~ encoding: utf-8 ~*~
#--
# Copyright (C) 2013  Florian Kasper
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++


require 'gollum-lib'
require 'active_model'
require 'active_support'

# GollumRails is a RubyGem for extending Rails and the Gollum wiki powered by github
# It has the ability to combine the benefits from a git powered wiki with Rails.
#
# Example solutions:
#   * Gollum Wiki pages - Devise authentication - GollumRails connector - Haml layouting
#   * Gollum Wiki pages - Ember.js - Handlebars layout - Rails REST API
#   * ...
#
module GollumRails
  extend ActiveSupport::Autoload
  
  autoload :Persistance
  autoload :Callbacks
  autoload :Error
  autoload :Core
  autoload :Store
  autoload :Validation
  autoload :Finders
  autoload :Page
  autoload :Setup
  autoload :Orm
  autoload :Meta

  # GollumRails version string
  VERSION = '1.4.14'

end

require 'gollum_rails/adapters/gollum'
