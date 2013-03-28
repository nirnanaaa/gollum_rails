require 'rubygems'
require 'bundler/setup'

require 'gollum_rails'

require 'benchmark'
RSpec::Matchers.define :take_less_than do |n|
  chain :seconds do; end
    match do |block|
      @elapsed = Benchmark.realtime do
        block.call
      end
      @elapsed <= n
    end
end

RSpec.configure do |config|
 config.treat_symbols_as_metadata_keys_with_true_values = true
 config.mock_with :rr

 config.before(:each) do
 end
 
end
