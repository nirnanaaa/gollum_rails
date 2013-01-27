Gollum for Rails
================

Gollum for Rails combines the benefits from gollum with the flexibility of Rails.

It improves the lightweight "gollum" experience which is quite awesome.

You can:

* Define your own views
* Use your Rails layouts
* Embed it without mounting something in your Rack app
* Use own preprocession e.g. Sidekiq for Async Syntax highlightning
* Use user Authentication e.g. Devise or Authlogic

## SYSTEM REQUIREMENTS
- Python 2.5+ (2.7.3 recommended)
- Ruby 1.8.7+ (1.9.3 recommended)
- Unix like operating system (OS X, Ubuntu, Debian, and more)
- Will not work on Windows (see [gollum](https://github.com/github/gollum/blob/master/README.md#system-requirements))

## INSTALLATION

Put

	gem 'gollum_rails'


in your `Gemfile`

Then just run the [Bundler](http://gembundler.com/)

	$ bundle install
	
If you want you can add an initializer into e.g. `config/initializers/gollum_rails.rb`

	Gollum::Rails::Wiki.new(<location>)

Now your gollum wiki is ready for use

If you want you can add a model the same way as normal `ActiveRecord` / `ActiveModel`

	class Page < Gollum::Rails::Page

	end
	
## Validating

Works like `ActiveRecord` / `ActiveModel` validation

some examples:

	# validates the presence of the Name (already embedded into to gem)
	validates_presence_of :name
	
	# forces the name to have a given format e.g. only 0-9 a-z and A-Z
	validates_format_of :name, :with => /^[a-zA-Z0-9_]+$/i
	
	# checks if the lenght of the content fit
	validates_length_of :content, :maximum => 500
	
## API

Accessible variables / methods are:

`Gollum::Rails::Page`

**Create a new Page:**

Example for existing model `Page`

	page = Page.new {:name => 'Example page',
					 :content => 'some very very very very long content',
					 :format => :markdown,
					 :commit => commit_data
					 }
	page.save
	
Thats it. Very easy. You can use also `page.save!` method.
	

## TODO
* List all pages
* Search pages
* embed gollum :markdown editor

## DEVELOPER

Very cool. Just fork this repository and send  pull requests ;)

### QUICK START

Clone the repository:

	$ git clone git://github.com/nirnanaaa/gollum_rails.git
	
Run the [Bundler](http://gembundler.com/):

	$ bundle install
	

### TESTING

First use the Quick Start to install all dependencys.
All tests are stored under the `test/` directory.

First you must create a `wiki` repository.

	$ git init test/wiki
	
To run tests just use the `rake` command:

	$ bundle exec rake

BE CAREFUL! THE FIRST TEST WILL FAIL BECAUSE THE NECESSARY STATIC FILES ARE NOT EXISTING


## EXAMPLE
## LICENSE
Copyright © 2013 Florian Kasper

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


