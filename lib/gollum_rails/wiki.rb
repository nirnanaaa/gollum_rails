require File.expand_path('../validations', __FILE__)
require File.expand_path('../file', __FILE__)
require File.expand_path('../page', __FILE__)

module GollumRails
  class Wiki
    class << self

    def new(path)
      initConfig
      gollum = getMainGollum path
      DependencyInjector.set({ :wiki => gollum, :wiki_path => gollum.path })
      return gollum
    end

    def initConfig
      return Config.read_rails_conf if DependencyInjector.in_rails?
      return Config.read_config
    end
    def getMainGollum(path)
      begin
        return ::Gollum::Wiki.new(path)  if path.is_a? ::String
      rescue ::Grit::NoSuchPathError
        DependencyInjector.set(:error => "No such git repository #{path.to_s}")
        return nil
      end
    end

    def search(string = '')

    end

    ## static setters / getters

  end
end
end
