module Gollum
  module Rails
    attr_accessor :app
    def setApp(app)
      send("app=", app)
    end
    def getApp
      @app
    end
  end
end