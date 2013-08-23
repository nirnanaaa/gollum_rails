require 'rubygems'
require 'bundler/setup'

require 'coveralls'
Coveralls.wear!

require 'gollum_rails'



RSpec.configure do |config|
 config.treat_symbols_as_metadata_keys_with_true_values = true

 config.before(:each) do
   GollumRails::Adapters::Gollum::Connector.enabled = true
 end

 config.mock_with :rr

 config.before(:each) do
 end
 
end
