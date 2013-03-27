require 'rubygems'
require 'bundler/setup'

require 'gollum_rails'

RSpec.configure do |config|
 config.treat_symbols_as_metadata_keys_with_true_values = true
 config.mock_with :rr

 config.before(:each) do
 end
 
end
