$:.push File.expand_path("../lib", __FILE__)
require 'irb'
require 'gollum_rails'

GollumRails::Setup.build{|d|d.repository='../../wiki.git'}
@p = GollumRails::Page.new(name: "abcde", format: :markdown, content: "test", commit: {name:"mosny" ,email:"mosny@zyg.li" ,message:"commit"})


IRB.start
