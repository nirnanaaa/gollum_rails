module GollumRails
    ## simple DI component
    class DependencyInjector

      attr_accessor :storage
      
      #initializes the :storage with a new Hash
      def self.initialize
        @storage = Hash.new
      end
      
      #sets a storage Hash
      def self.set(name, value)
        if !@storage.is_a?(Hash)
          self.initialize
        end  
        @storage[name] = value
      end

      # gets a storage
      def self.get(name)
        if !@storage.is_a?(Hash)
          self.initialize
        end
        @storage[name]
      end
    end
end