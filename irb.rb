$:.push File.expand_path("../lib", __FILE__)
require 'pry'
require 'gollum_rails'

GollumRails::Setup.build{|d|d.repository='../../wiki.git'}
c = {name: "mosny", email: "mosny@zyg.li", message: "testmessage"}
p = GollumRails::Page.new(name: "abcde", format: :markdown, content: "test", commit: c)


Pry.start self
