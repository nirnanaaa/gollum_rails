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
#PATCHES
require 'rugged'
def exp(path)
  File.expand_path("../#{path}",__FILE__)
end
require exp('rugged/commit')
require exp('gollum-lib/git_access')
require exp('gollum-lib/blob_entry')
require exp('gollum-lib/committer')
require exp('gollum-lib/markup')
require exp('gollum-lib/wiki')
require exp('gollum-lib/file')
require exp('gollum-lib/page')
require exp('gollum-lib/filter/code')


#/PATCHES
require 'active_model'
require 'active_support'

# GollumRails is a RubyGem for extending Rails and the Gollum wiki powered by github
# It has the ability to combine the benefits from a git powered wiki with Rails.
#
#
module GollumRails
  extend ActiveSupport::Autoload

  autoload :Persistance
  autoload :Callbacks
  autoload :Error
  autoload :Attributes
  autoload :Core
  autoload :Store
  autoload :Validation
  autoload :Finders

  autoload :Page
  autoload :Upload

  autoload :Item
  autoload :Setup
  autoload :Orm
  autoload :Meta

  # GollumRails version
  VERSION = '1.6.0'

end

