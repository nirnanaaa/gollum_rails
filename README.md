Gollum for Rails
================
[![Build Status](https://travis-ci.org/nirnanaaa/gollum_rails.png?branch=master)](https://travis-ci.org/nirnanaaa/gollum_rails)
[![Dependency Status](https://gemnasium.com/nirnanaaa/gollum_rails.png)](https://gemnasium.com/nirnanaaa/gollum_rails)
[![Gem Version](https://badge.fury.io/rb/gollum_rails@2x.png)](http://badge.fury.io/rb/gollum_rails)
[![Coverage Status](https://coveralls.io/repos/nirnanaaa/gollum_rails/badge.png?branch=master)](https://coveralls.io/r/nirnanaaa/gollum_rails)
[![Code Climate](https://codeclimate.com/github/nirnanaaa/gollum_rails.png)](https://codeclimate.com/github/nirnanaaa/gollum_rails)

gollum_rails combines the git-powered wiki software gollum with the extreme popular webframework rails.
It improves the lightweight "gollum" experience which is quite awesome.

with gollum_rails you can:

* Define your own views
* Use your Rails layouts
* Embed gollum it without mounting any rack application
* Use own preprocession e.g. background workers for data procession
* Use user authentication e.g. Devise or Authlogic

For an Editor to use with gollum_rails I personally like the [gollum_editor](https://github.com/samknight/gollum_editor)

It provides nearly the same features as the official editor.

## SYSTEM REQUIREMENTS
- Python 2.5+ (2.7.3 recommended)
- Ruby 1.9.3+ (2.0.0 recommended)
- Unix like operating system (OS X, Ubuntu, Debian, and more)
- Will not work on Windows (see [gollum](https://github.com/github/gollum/blob/master/README.md#system-requirements))

## [Installation](https://github.com/nirnanaaa/gollum_rails/wiki/Installation)

## [Usage](https://github.com/nirnanaaa/gollum_rails/wiki/Usage)



## DEVELOPER

Very cool. Just fork this repository and send me pull requests.

### QUICK START

Clone the repository:

    $ git clone git://github.com/nirnanaaa/gollum_rails.git

Run the [Bundler](http://gembundler.com/):

    $ bundle install


### TESTING

First use the Quick Start to install all dependencies.
All tests are stored under the `spec/` directory.

To run tests just use the `rspec` command:

    $ bundle exec rspec

## LICENSE

[![AGPLv3](http://www.gnu.org/graphics/agplv3-155x51.png)](http://www.gnu.org/licenses/agpl-3.0.en.html)

gollum_rails is licensed under the AGPL license.

Copyright (C) 2013  Florian Kasper

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
