
module GollumRails

  # Public: GollumRails::Wiki
  #
  class Wiki

    # Public: Singleton class
    class << self

    # Public: Spawns a new Gollum::Wiki
    #
    # path - A string, maybe empty if in Rails env
    # settings - A hash, Framework environment
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

    # Public: searches the whole wiki (DEPRECATED)
    #
    # use Page.search instead, which is a Page plugin
    #
    def search(string = '')

    end

    ## static setters / getters

  end
end
end
