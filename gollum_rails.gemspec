Gem::Specification.new do |s|
   s.name = 'gollum_rails'
   s.version = '0.0.2.1'
   
   s.summary = 'Combines the benefits from Gollum with Rails'
   s.description= 'use templating, authentication and so on'
   #File.read(File.join(File.dirname(__FILE__), 'README.md'))
   
   s.add_dependency('activemodel', '~> 3.2.11')
   s.add_dependency('gollum', '~> 2.4.11')
   s.add_dependency('grit', '~> 2.5.0')
   s.add_dependency('builder', '~> 3.0.0')
   s.add_dependency('rack', '~> 1.4.0')
   s.add_development_dependency('org-ruby', '~> 0.7.2')
   s.add_development_dependency('shoulda', '~> 3.3.2')
   s.add_development_dependency('rack-test', '~> 0.6.2')
   s.add_development_dependency('rake', '~> 10.0.2')
   s.add_development_dependency('rails', '~> 3.2.11')
   
   s.author = 'nirnanaaa'
   s.email = 'nirnanaaa@khnetworks.com'
   s.homepage = 'https://github.com/nirnanaaa/gollum_rails'
   s.platform = Gem::Platform::RUBY
   s.required_ruby_version = '>=1.9'
   s.files = %w[
     Gemfile
     HISTORY.md
     gollum_rails.gemspec
     LICENSE.md
     README.md
     lib/gollum_rails.rb
     lib/gollum/rails/dependency_injector.rb
     lib/gollum/rails/page.rb
     lib/gollum/rails/validations.rb
     lib/gollum/rails/wiki.rb
     lib/gollum/rails/version.rb
     lib/gollum/rails/gollum_rails.rb
     lib/gollum/rails/engine.rb
     lib/gollum/rails/config.rb
     lib/gollum/rails/messages.yml
     lib/gollum/rails/hash.rb
   ]
   s.require_paths = %w[lib]
   s.has_rdoc = false
   s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end