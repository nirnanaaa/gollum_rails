$:.push File.expand_path("../../lib", __FILE__)
require 'gollum_rails'
require 'benchmark'
require 'benchmark/ips'

GollumRails::Setup.build do |s|
  s.repository = File.expand_path('../ex.git',__FILE__)
end
Benchmark.ips do |ips|
  ips.report("find a page"){GollumRails::Page.find("home")}
end
