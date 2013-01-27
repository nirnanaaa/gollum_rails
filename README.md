Gollum for Rails
================
[![Build Status](https://travis-ci.org/nirnanaaa/gollum_rails.png?branch=master)](https://travis-ci.org/nirnanaaa/gollum_rails)

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

	GollumRails::Wiki.new(<location>)

Now your gollum wiki is ready for use

If you want you can add a model the same way as normal `ActiveRecord` / `ActiveModel`

	class Page < GollumRails::Page

	end
	
## API

Accessible variables / methods are:

For: `GollumRails::Page`

Every action returns a `String`, containing the commit id of the current action

First: For each action you write on a wiki page, a commit must be given. So lets do this. The commit MUST be a `Hash`

	commit_data = {
      				:message => "test action on page",
      				:name => 'Florian Kasper',
      				:email => 'nirnanaaa@khnetworks.com'
    		      }
    		      
**Create a new Page:**

Example for existing model `Page`

	page = Page.new {:name => 'Example page',
					 :content => 'some very very very very long content',
					 :format => :markdown,
					 :commit => commit_data
					 }
	page.save
	
Thats it. Very easy. You can use also `page.save!` method.
	
	
**Update an existing page**

	page = Page.new
	page.find('Example page')
	page.update('some very long content', commit_data)
	
	# you can also change the name
	
	page.update('some very long content', commit_data, 'new-name')
	
	# and the format (page will be recreated)
	
	page.update('some very long content', commit_data, nil, :wiki)
	
	
**Delete a page**
	
	page = Page.new
	page.find('Example page')
	page.delete
	
	# or
	
	page.delete!
	
	# for getting errors instead of `NIL`

**Set data manually**

	page = Page.new

    page.name = "testpage"
    page.content = "content"
    page.format = :markdown
    page.commit = {
      				:message => "test action on page",
      				:name => 'Florian Kasper',
      				:email => 'nirnanaaa@khnetworks.com'
    		      }
    
**Preview a page (AJAX/or not)**

	page = Page.new
	preview = page.preview("testpage", "content") # or page.preview("testpage", "content", :format)
	
	# preview contains the HTML rendered data!
			
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