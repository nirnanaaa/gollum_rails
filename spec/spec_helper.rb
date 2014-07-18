require 'rubygems'
require 'bundler/setup'

require 'coveralls'
Coveralls.wear!

require 'gollum_rails'
require 'factory_girl'



I18n.enforce_available_locales = false

Dir[File.expand_path('../support/**/*.rb',__FILE__)].each { |f| require f }
require File.expand_path('../factories.rb', __FILE__)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    FactoryGirl.lint
  end
end
