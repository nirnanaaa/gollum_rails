
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
           if DependencyInjector.rails_conf.location_type.to_s == "relative"
            gollum = getMainGollum DependencyInjector.app.root.join(DependencyInjector.rails_conf.location)
           else
            gollum = getMainGollum DependencyInjector.rails_conf.location
           end
        end
      else
        #STANDALONE
          gollum = getMainGollum path
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
      rescue ::Grit::NoSuchPathError => e
        raise RuntimeError, e
      end
    end

    def search(string = '')

    end

    ## static setters / getters

  end
end
end
