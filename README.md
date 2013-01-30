Gollum for Rails
================
[![Build Status](https://travis-ci.org/nirnanaaa/gollum_rails.png?branch=master)](https://travis-ci.org/nirnanaaa/gollum_rails)
[![Dependency Status](https://gemnasium.com/nirnanaaa/gollum_rails.png)](https://gemnasium.com/nirnanaaa/gollum_rails)

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

To install GollumRails just run the `generator`

  $ rails g gollum_rails:install

  # for help
  $ rails g gollum_rails:install --help

If you want you can add an initializer into e.g. `config/initializers/gollum_rails.rb`
instead of installing the application.

	GollumRails::Wiki.new(<location>)

Now your gollum wiki is ready for use


To create a new ActiveModel / GollumRails::Page just run

	rails g gollum_rails:model <page>
	# make sure that the file does not exist

## CONFIGURATION

The "main" configuration file is located under  `config/gollum.yml` in your Rails app

Content:

  # value: relative / absolute / auto
  #
  # relative will result in 'relative to Rails root/'
  # absolute will result in '/'
  # auto will result in either /(prefixed) or <railsroot/>path
  #
  location_type: relative

  #   location: db/wiki
  #   # or
  #   location: /var/www/wiki
  #
  location: db/wiki

  #   # use
  #   i18n_messages: true
  #   # don't use
  #   i18n_messages: false
  #
  i18n_messages: true

  # Throw exceptions or only set `error` method
  throw_exceptions: false

If  you have `i18n` support enabled you should have a look at
`RAILSROOT/config/locales/gollum.<LANG>.yml`
which is already filled.

Format:

  gollum_messages:
    <identifier>: <translated>


## USAGE

Accessible variables / methods are:

For: `GollumRails::Page`

Every action, performing on a page returns a `String`, containing the commit id of the current action

**For each action you write on a wiki page, a commit must be given. The commit MUST be a `Hash`**

	commit_data = {
      				:message => "what you have done?",
      				:name => 'Florian Kasper',
      				:email => 'nirnanaaa@khnetworks.com'
    		      }


***


**Create a new Page:**

Example for existing model `Page`

	page = Page.new {
                   # an intuitive name
                   # spaces will be replaced with `-` in file names and `-` will
                   # be replaced with `____`(4 underscores)
                   :name => 'Example page', #filename would be `Example-page` in this case

                   # foobar
                   :content => 'some very very very very long content',

                   # for possible types see [wiki page](/nirnanaaa/gollum_rails/wiki/supported-formats)
                   :format => :markdown,

                   # from above
					         :commit => commit_data
					 }
  # saves the page in your Git repository
	page.save
  # there is also a `.save!` method to override the `config.throw_exceptions` and throw an exception on error

Thats it. Very easy.


***


**Update an existing page**

	page = Page.new
	page.find('Example page')
	page.update('some very long content', commit_data)

	# you can also change the name

	page.update('some very long content', commit_data, 'new-name')

	# and the format (page will be recreated)

	page.update('some very long content', commit_data, nil, :wiki)


***


**Delete a page**

  #### Since v0.0.3
  # first you must have a Page instance
  found = Page.find('Example page')

  found.delete(commit_data)

  # or
	Page.delete(found, commit_data)

	# also you may wanna use `delete!`
  ####

***


**Setting data manually**

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

**Show pages versions**

	page = Page.new
	page.find("testpage")
	versions = page.versions

	versions.all
	# => #<Grit::Commit "83a5e82a58eb4afda2662b7ca665b64554baf431">,
 		 #<Grit::Commit "3a12080810acaf5cff3c2fb9bf67821943033548">,
 		 #<Grit::Commit "3b9ee74806b5cd59ec7d01fe4d974aa9974c816e">,
 		 #<Grit::Commit "c1507f5c47ae5bee16dea3ebed2f177dbcf48a68">,


	versions.latest
	# => #<Grit::Commit "3a12080810acaf5cff3c2fb9bf67821943033548">

	versions.oldest
	# => #<Grit::Commit "6d71571d379cfe863933123ea93dea4aac1d6eb64">

	versions.find("6d71571d379cfe86393135ea93dea4aac1d6eb64")
	# => #<Grit::Commit "6d71571d379cfe863933123ea93dea4aac1d6eb64">


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
