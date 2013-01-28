# ~*~ encoding: utf-8 ~*~
module GollumRails
  class Versions

    # Public: Gets the versions
    attr_reader :versions
    
    def initialize(page)
      @versions = page.versions
    end

    # Public: .first
    #
    # Examples
    #   oldest
    #   # => #<Grit::Commit "6d71571d379cfe863933123ea93dea4aac1d6eb64"> 
    #
    #
    # Returns the latest instance of Grit::Commit
    def latest
      return @versions.first
    end

    # Public: Last position in the @versions Array
    #
    # Examples
    #   oldest
    #   # => #<Grit::Commit "6d71571d379cfe863933123ea93dea4aac1d6eb64"> 
    #
    #
    # Returns the oldest version of Grit::Commit
    def oldest
      return @versions.last
    end

    # Public: An Array of Grit::Commit
    #
    #
    # Examples
    #   all
    #   # =>   <Grit::Commit "b3cc54c974700391d3f1c3c108032b6a5f27ecd8">,
    #          <Grit::Commit "13cda30e2a292852a32fad1e9c547c523387f17e">,
    #          <Grit::Commit "83a5e82a58eb4afda2662b7ca665b64554baf431">,
    #          <Grit::Commit "3a12080810acaf5cff3c2fb9bf67821943033548">,
    #          <Grit::Commit "3b9ee74806b5cd59ec7d01fe4d974aa9974c816e">,
    #          <Grit::Commit "c1507f5c47ae5bee16dea3ebed2f177dbcf48a68">,
    #          <Grit::Commit "1979f67c509c2802234dc12f242999953ffd9bc7">,
    #          <Grit::Commit "01fb119db9cb59b339011c7c9e5e59b89bf9a7a2">,
    #          <Grit::Commit "650cfd42814cf2d9fd0e2e9b7262f77bad06d0e0">,
    #          <Grit::Commit "07dfb9a86e7045369fc57c8d43e8cf68d3dfe7d1">,
    #          ...
    #
    # Returns many instances of Grit::Commit
    def all
      return @versions
    end

    # Public: Find a specific version
    #
    # version - String, containing the GIT version number
    #
    # Examples
    #   find '6d71571d379cfe86393135ea93dea4aac1d6eb64'
    #   # => #<Grit::Commit "6d71571d379cfe86393135ea93dea4aac1d6eb64">
    #
    #
    # Returns an instance of Gollum::Page
    def find(version = String.new)
      result = nil
      @versions.each do |commit|
        if commit.id == version
          result = commit
        end
      end
      return result
    end
    
  end
end