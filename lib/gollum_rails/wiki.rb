
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
    def new(path = String.new, settings = {})
      Config.read_config

      #path is nil
      if path == nil and settings
        Config.read_rails_conf
        if settings.env == :rails &&
           DependencyInjector.in_rails
           gollum = getMainGollum DependencyInjector.rails_conf.location
        end
      else
        #STANDALONE
          gollum = getMainGollum DependencyInjector.app.path.join(path)
      end
      DependencyInjector.set({ :wiki => gollum, :wiki_path => gollum.path })
      return gollum
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
        return ::Gollum::Wiki.new(path)
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
