Gem::Specification.new do |s|
  s.rubygems_version = '>= 1.3.5'
  
  s.name = 'gollum_rails'
  s.rubyforge_project = s.name

  s.version = '0.0.8'

  s.summary = 'Combines the benefits from Gollum and Rails'
  s.description= 'Use all the benefits from Rails and combine them with the awesome Gollum wiki'
  #File.read(File.join(File.dirname(__FILE__), 'README.md'))

  s.add_dependency 'activemodel', '~> 3.2.13'
  s.add_dependency 'gollum-lib', '~> 0.0.1'
  #s.add_dependency 'grit', '~> 2.5.0'
  s.add_dependency 'builder', '~> 3.0.0'
  s.add_dependency 'rack', '~> 1.4.5'

  s.add_development_dependency 'rspec', '~> 2.13.0'
  s.add_development_dependency 'rails', '~> 3.2.13'
  s.add_development_dependency 'rr', '~> 1.0.4' 
  s.add_development_dependency 'rails', '~> 3.2.13'

  s.author = 'Florian Kasper'
  s.email = 'mosny@zyg.li'
  s.homepage = 'http://gollum.zyg.li'
  s.license = 'AGPL'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>=1.9.3'

  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    HISTORY.md
    LICENSE
    README.md
    Rakefile
    examples/rails/initializer.rb
    gollum_rails.gemspec
    lib/generators/gollum_rails/install/install_generator.rb
    lib/generators/gollum_rails/install/templates/gollum_initializer.rb
    lib/generators/gollum_rails/language/language_generator.rb
    lib/generators/gollum_rails/model/model_generator.rb
    lib/generators/gollum_rails/model/templates/model_template.erb
    lib/gollum_rails.rb
    lib/gollum_rails/adapters/activemodel.rb
    lib/gollum_rails/adapters/activemodel/boolean.rb
    lib/gollum_rails/adapters/activemodel/error.rb
    lib/gollum_rails/adapters/activemodel/naming.rb
    lib/gollum_rails/adapters/activemodel/validation.rb
    lib/gollum_rails/adapters/gollum.rb
    lib/gollum_rails/adapters/gollum/.gitkeep
    lib/gollum_rails/adapters/gollum/committer.rb
    lib/gollum_rails/adapters/gollum/error.rb
    lib/gollum_rails/adapters/gollum/page.rb
    lib/gollum_rails/adapters/gollum/wiki.rb
    lib/gollum_rails/initializer.rb
    lib/gollum_rails/modules/hash.rb
    lib/gollum_rails/modules/loader.rb
    lib/gollum_rails/page.rb
    lib/gollum_rails/setup.rb
  ]
  # = MANIFEST =


  s.require_paths = %w[lib]
  s.post_install_message = "Important: \n\n" \
  "**********************************************\n\n" \
  "To use the 'autoinitializer' just run the following command:\n\n"\
  "\trails g gollum_rails:install\n\n"\
  "To generate a new Page model just run:\n\n"\
  "\trails g gollum_rails:model MODEL_NAME\n"\
  "**********************************************"
end

