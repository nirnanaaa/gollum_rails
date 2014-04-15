require 'rubygems'
require 'bundler/setup'

require 'coveralls'
Coveralls.wear!

require 'gollum_rails'



I18n.enforce_available_locales = false
RSpec.configure do |config|
 config.treat_symbols_as_metadata_keys_with_true_values = true
end
