guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^lib/(orm|core|finders|persistance|store|callbacks)\.rb$}) { |m| "spec/gollum_rails/page_spec.rb" }

end

