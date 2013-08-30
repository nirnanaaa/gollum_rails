# 1.4.3 1th September 2013
* Display the current pages version (short OR long)
* Display if the page is a sub page
* Display the pages filename
* Improved specs
* Refactored find method to return nil if no page was found (BUG)
* Refactored find_or_initialize_by_name to be useable :)

# 1.4.2 1th August 2013
* Found an issue that the Wiki was not updating from external pushes
* Some helper methods implemented
* Improved code quality
* Should be threadsaver now
* Updated documentation

# 1.4.1 26th June 2013
* Rails4

# 1.0.4 1th May 2013
* removed mutex again
* added gemspec name to Gemfile
* removed odd modules
* updated description
* improved documentation
* removed unused activemodel adapters
* added fancy inspects
* concept to make gollum page adapter threadsave
* new documentation standard
* removed unused GollumRails::Adapters::Gollum::Committer (unused)
* removed .gitkeep from filled directories
* removed old and deprecated require style


# 1.0.3 25th April 2013
* fixed post install messsage
* removed unused require statements
* removed gitlab-grit

# 1.0.2 23th April 2013
* added standalone compability for ruby 2.0
* added patches by styx
* added string corext for ruby2
* added mutex locks for ugly threadsave

# 1.0.1 5th April 2013
* added find_all and all for Page
* removed some unused functions
* added autoloading
* improved documentation
* improved code coverage

# 1.0.0 3th April 2013
* added validators
* removed unused gems
* updated documentation
* removed unused middleware
* improved code coverage

# 0.0.8 1th April 2013
* updated documentation
* removed unused code

# 0.0.7 1th April 2013
* improved installation instructions
* improved performance

# 0.0.6 1th April 2013
* missing generators added

# 0.0.5 31th March 2013
* Fully working create!, create, find, save, update_attributes, find_by_(name|format)
* 100% code coverage

# 0.0.4 29th March 2013
* Adapters for Gollum and ActiveRecord

# 0.0.3 10th February 2013

* create added
* 100% documentation
* modular functions
* installation generator
* module generator

# 0.0.2.9 30th January 2013

* Singleton classes for dynamic modules
* Page.find is now static useable, as well as delete, update, safe

# 0.0.2.8 28th January 2013

* quick generator fail fix

# 0.0.2.7 28th January 2013

* added versioning support

# 0.0.2.5 27th January 2013

* added page preview
* improved dependency injection

# 0.0.2 27th January 2013

* Refactored modules prefix
* Updated Documentation
* Removed validation
* Added Rails module support
