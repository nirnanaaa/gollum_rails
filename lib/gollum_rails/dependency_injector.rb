module GollumRails
  ## simple DI component
  class DependencyInjector

    # Public: Storage for error
    @storage = {}

    # Public: Reads either error or error_old
    def self.get_error_buffer
      error ||= error_old
    end


    # Public: block assignment
    #
    # block - Block of Enumerables
    #
    #
    def self.register(&block)
      block.call(self)
    end

    # Public: setter
    #
    # arguments - Hash of arguments
    #
    # Returns arguments
    def self.set(arguments = {})
      arguments.each{ |key, value| @storage[key] = value}
    end

    # Public: expects arguments or a block
    #
    # method - .call
    # arguments - Array of additional arguments (unused, DEPRECATED)
    # block - Get  block variables
    #
    def self.method_missing(method, *arguments, &block)
      if @storage[method]
        return @storage[method]
      else
        return false
      end
    end
  end
end
