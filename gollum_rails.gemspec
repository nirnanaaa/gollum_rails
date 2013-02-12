Gem::Specification.new do |s|
  s.rubygems_version = '1.3.5'
  s.name = 'gollum_rails'
  s.version = '0.0.2.9'

  s.summary = 'Combines the benefits from Gollum with Rails'
  s.description= 'use templating, authentication and so on'
  #File.read(File.join(File.dirname(__FILE__), 'README.md'))

  s.add_dependency('activemodel', '~> 3.2.11')
  s.add_dependency('gollum', '~> 2.4.11')
  s.add_dependency('grit', '~> 2.5.0')
  s.add_dependency('builder', '~> 3.0.0')
  s.add_dependency('rack', '~> 1.4.0')

  s.add_development_dependency('org-ruby', '~> 0.8.0')
  s.add_development_dependency('shoulda', '~> 3.3.2')
  s.add_development_dependency('rack-test', '~> 0.6.2')
  s.add_development_dependency('rake', '~> 10.0.2')
  s.add_development_dependency('rails', '~> 3.2.12')

  s.author = 'Florian Kasper'
  s.email = 'nirnanaaa@khnetworks.com'
  s.homepage = 'https://github.com/nirnanaaa/gollum_rails'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.8.7'

  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    HISTORY.md
    LICENSE.md
    README.md
    Rakefile
    gollum_rails.gemspec
    lib/generators/gollum_rails/install/install_generator.rb
    lib/generators/gollum_rails/install/templates/gollum.yml
    lib/generators/gollum_rails/install/templates/messages.yml
    lib/generators/gollum_rails/model/model_generator.rb
    lib/generators/gollum_rails/model/templates/model.rb.erb
    lib/gollum_rails.rb
    lib/gollum_rails/config.rb
    lib/gollum_rails/dependency_injector.rb
    lib/gollum_rails/engine.rb
    lib/gollum_rails/file.rb
    lib/gollum_rails/hash.rb
    lib/gollum_rails/messages.yml
    lib/gollum_rails/page.rb
    lib/gollum_rails/page/actions.rb
    lib/gollum_rails/page/delete.rb
    lib/gollum_rails/page/find.rb
    lib/gollum_rails/page/helper.rb
    lib/gollum_rails/page/save.rb
    lib/gollum_rails/page/update.rb
    lib/gollum_rails/page/versions.rb
    lib/gollum_rails/validations.rb
    lib/gollum_rails/wiki.rb
  ]
  # = MANIFEST =



  s.require_paths = %w[lib]
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8"]
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
  s.post_install_message = "Important: \n\n" \
  "**********************************************\n\n" \
  "To use the 'autoinitializer' just run the following command:\n\n"\
  "\t\trails g gollum_rails:install\n\n"\
  "To generate a new Page model just run:\n\n"\
  "\t\rails g gollum_rails:model MODEL_NAME"\
  "**********************************************"
end

