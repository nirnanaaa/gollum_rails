require File.expand_path('../validations', __FILE__)
require File.expand_path('../file', __FILE__)
require File.expand_path('../page', __FILE__)
require File.expand_path('../hash', __FILE__)

module GollumRails
  class Wiki
    class << self

    # Public: Spawns a new Gollum::Wiki
    #
    #
    # Examples
    #   Wiki.new("/home/nirnanaaa/wiki")
    #   # => Gollum::Wiki
    #
    #
    # Returns a new Gollum::Wiki instance
    def new(path)
      initConfig
      if path != :rails
        gollum = getMainGollum path
      else
        if DependencyInjector.in_rails?
          conf = DependencyInjector.rails_conf
          puts conf
          gollum = getMainGollum conf.location
        end
      end
      DependencyInjector.set({ :wiki => gollum, :wiki_path => gollum.path })
      return gollum
    end

    # Public: initiates the configuration
    #
    #
    # Returns either the Rails configuration or the internal if Rails is not loaded
    def initConfig
      return Config.read_rails_conf if DependencyInjector.in_rails?
      return Config.read_config
    end

    # Public: fetches the Gollum WIKI
    #
    # path - String, containing the GIT repositorys location
    #
    # Examples
    #   getMainGollum /home/nirnanaaa/wiki
    #   # => Gollum::Wiki
    #
    # Returns either nil or Gollum::Wiki
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
