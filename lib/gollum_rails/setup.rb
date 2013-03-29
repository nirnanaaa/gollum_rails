module GollumRails

  class Setup
    class << self
      

      # Gets / Sets the repository
      attr_accessor :repository

      # Startup action for building wiki components
      #
      # Returns true or throws an exception if the path is invalid
      def startup
        if path_valid? @repository
          repository = Grit::Repo.new @repository.to_s
          GollumRails::Adapters::Gollum::Wiki.new repository
          true
        else
          raise GollumInternalError, 'no repository path specified'
        end
      end
      
      # defines block builder for Rails initializer.
      # executes public methods inside own class
      #
      def build(&block)
        block.call self
      end

      #######
      private
      #######

      def path_valid?(path)
        return !(path.nil? || path.empty? || ! path.is_a?(String))
      end

    end
  end
end
