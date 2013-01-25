Gem::Specification.new do |s|
   s.name = "gollum_rails"
   s.version = "0.0.1"
   s.summary = "Combines Gollum wiki with Rails"
   s.description= File.read(File.join(File.dirname(__FILE__), 'README.md'))
   s.requirements =[ ]
   s.author = "Alexander Danzer"
   s.email = "alexander.danzer@corscience.de"
   s.homepage = "http://git/?p=adanzer/logparser.git;a=summary"
   s.platform = Gem::Platform::RUBY
   s.required_ruby_version = '>=1.9'
   s.files = ['lib/logparser.rb', 'encodings.yml',
     'protocol_cardiaid.yml', 'protocol_easy.yml']
   s.require_paths = ["lib"]
   s.has_rdoc = false
end