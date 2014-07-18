module GollumRails


  # = GollumRails
  #
  # Gollum Rails was initially designed to integrate the Gollum wiki software
  # into your Rails application without any mounts or extra applications to run.
  #
  # Now you can use your completely own layout without struggling with gollum forks.
  #
  # Just integrate this gem into your Gemfile and you are good to go:
  #
  #   gem install gollum_rails
  #
  # or in your Gemfile:
  #
  #   gem 'gollum_rails'
  #
  #
  # If you want to use this gem with Rails version prior 4.0.0 please check out the rails3
  # branch on Github:
  #
  # https://github.com/nirnanaaa/gollum_rails/tree/rails3
  #
  #
  # == Initialization
  #
  # To make full use of GollumRails you need to enable it in an initializer by genating it:
  #
  #   rails g gollum_rails:install
  #
  # Now you can add the path to your Repository in there.
  #
  # Also you need to set the <tt>startup</tt> boolean to <tt>true</tt>.
  #
  #
  #
  # == Page model
  #
  # You also need a model à la ActiveRecord by calling:
  #
  #   rails g gollum_rails:model Page
  #
  #
  # == Creation of a Page
  #
  # <b>Each action in a Git repository needs a Commit, which identifies the author!</b>
  #
  #   commit = { name: 'nirnanaa', email: 'mosny@zyg.li', message: 'created page page'}
  #   Page.create(name: 'test_page', content: 'content', format: :markdown, commit: commit)
  #
  #   Page.create!(name: 'test_page', content: 'content', format: :markdown, commit: commit)
  #
  # The <tt>!</tt> version of the method throws an error on failure.
  #
  #
  #   page = Page.new(name: 'test_page', content: 'content', format: :markdown, commit: commit)
  #   page.save
  #
  #   # OR
  #
  #   page.save!
  #
  #
  #
  #
  class Page
    if ActiveModel::VERSION::MAJOR == 4
      include ActiveModel::Model
    else
      extend ActiveModel::Naming
      extend ActiveModel::Callbacks
      include ActiveModel::Conversion
      include ActiveModel::Validations
    end
    include Error
    include Attributes
    include Core
    include Meta
    include Store
    include Validation
    include Persistance
    include Finders
    include Callbacks
  end
  ActiveSupport.run_load_hooks(:gollum, Page)
end
