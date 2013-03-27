Gem::Specification.new do |s|
  s.rubygems_version = '>= 1.3.5'
  
  s.name = 'gollum_rails'
  s.rubyforge_project = s.name

  s.version = '0.0.3'

  s.summary = 'Combines the benefits from Gollum and Rails'
  s.description= 'Use all the benefits from Rails and combine them with the awesome Gollum wiki'
  #File.read(File.join(File.dirname(__FILE__), 'README.md'))

  s.add_dependency 'activemodel', '~> 3.2.13'
  s.add_dependency 'gollum-lib', '~> 0.0.1'
  s.add_dependency 'grit', '~> 2.5.0'
  s.add_dependency 'builder', '~> 3.0.0'
  s.add_dependency 'rack', '~> 1.4.5'

  s.add_development_dependency 'rspec', '~> 2.13.0'
  s.add_development_dependency 'rails', '~> 3.2.13'
  s.add_development_dependency 'rr', '~> 1.0.4' 
  s.add_development_dependency 'rails', '~> 3.2.13'

  s.author = 'Florian Kasper'
  s.email = 'mosny@zyg.li'
  s.homepage = 'https://github.com/nirnanaaa/gollum_rails'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9.3'

  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    HISTORY.md
    LICENSE.md
    README.md
    Rakefile
    gollum_rails.gemspec
    lib/generators/gollum_rails/install/editor_generator.rb
    lib/generators/gollum_rails/install/install_generator.rb
    lib/generators/gollum_rails/install/templates/editor/gollum.editor.js
    lib/generators/gollum_rails/install/templates/editor/gollum.editor.min.js
    lib/generators/gollum_rails/install/templates/editor/langs/asciidoc.js
    lib/generators/gollum_rails/install/templates/editor/langs/creole.js
    lib/generators/gollum_rails/install/templates/editor/langs/markdown.js
    lib/generators/gollum_rails/install/templates/editor/langs/org.js
    lib/generators/gollum_rails/install/templates/editor/langs/pod.js
    lib/generators/gollum_rails/install/templates/editor/langs/rdoc.js
    lib/generators/gollum_rails/install/templates/editor/langs/textile.js
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
    lib/gollum_rails/page.rb
    lib/gollum_rails/page/actions.rb
    lib/gollum_rails/page/create.rb
    lib/gollum_rails/page/delete.rb
    lib/gollum_rails/page/find.rb
    lib/gollum_rails/page/helper.rb
    lib/gollum_rails/page/new.rb
    lib/gollum_rails/page/save.rb
    lib/gollum_rails/page/search.rb
    lib/gollum_rails/page/update.rb
    lib/gollum_rails/page/versions.rb
    lib/gollum_rails/validations.rb
    lib/gollum_rails/wiki.rb
    spec/gollum_rails/page_spec.rb
    spec/gollum_rails/respository_spec.rb
    spec/gollum_rails/wiki_spec.rb
    spec/spec.opts
    spec/spec_helper.rb
  ]
  # = MANIFEST =


  s.require_paths = %w[lib]
  s.post_install_message = "Important: \n\n" \
  "**********************************************\n\n" \
  "To use the 'autoinitializer' just run the following command:\n\n"\
  "\t\trails g gollum_rails:install\n\n"\
  "To generate a new Page model just run:\n\n"\
  "\t\rails g gollum_rails:model MODEL_NAME"\
  "**********************************************"
end

