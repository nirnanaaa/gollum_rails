Gem::Specification.new do |s|
  s.rubygems_version = '>= 1.3.5'

  s.name = 'gollum_rails'
  s.rubyforge_project = s.name

  s.version = '1.0.2'

  s.summary = 'Combines the benefits from Gollum and Rails'
  s.description= 'Use all the benefits from Rails and combine them with the awesome Gollum wiki'

  s.add_dependency 'activemodel', '~> 3.2.13'
  s.add_dependency 'gollum-lib', '~> 1.0.0'

  s.add_development_dependency 'rspec', '~> 2.13.0'
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
    gollum_rails.gemspec
    lib/core_ext/string.rb
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
    lib/gollum_rails/adapters/gollum.rb
    lib/gollum_rails/adapters/gollum/.gitkeep
    lib/gollum_rails/adapters/gollum/committer.rb
    lib/gollum_rails/adapters/gollum/error.rb
    lib/gollum_rails/adapters/gollum/page.rb
    lib/gollum_rails/adapters/gollum/wiki.rb
    lib/gollum_rails/modules/hash.rb
    lib/gollum_rails/modules/loader.rb
    lib/gollum_rails/page.rb
    lib/gollum_rails/setup.rb
    lib/grit/git-ruby/internal/pack.rb
    spec/gollum_rails/adapters/activemodel/error_spec.rb
    spec/gollum_rails/adapters/activemodel/naming_spec.rb
    spec/gollum_rails/adapters/activemodel/validation_unused.rb
    spec/gollum_rails/adapters/gollum/committer_spec.rb
    spec/gollum_rails/adapters/gollum/connector_spec.rb
    spec/gollum_rails/adapters/gollum/error_spec.rb
    spec/gollum_rails/adapters/gollum/page_spec.rb
    spec/gollum_rails/adapters/gollum/wiki_spec.rb
    spec/gollum_rails/modules/hash_spec.rb
    spec/gollum_rails/page_spec.rb
    spec/gollum_rails/respository_spec.rb
    spec/gollum_rails/setup_spec.rb
    spec/gollum_rails/wiki_spec.rb
    spec/spec.opts
    spec/spec_helper.rb
  ]
  # = MANIFEST =


  s.require_paths = %w[lib]
  s.post_install_message = <<-END
  Important: \n
  To enable gollum_rails run the following command:
  \trails g gollum_rails:install\n
  To generate a new Page model just run:
  \trails g gollum_rails:model MODEL_NAME\n
  To install an additional parsing language run:
  \trails g gollum_rails:language LANGUAGE
  END
end
