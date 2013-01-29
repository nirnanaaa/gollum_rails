module GollumRails
  class CommitMustBeGivenError < StandardError; end
  class NoPageLoadedError < StandardError; end
  class PageHelper
    class << self
      def initialized_first
        DependencyInjector.set({ :error_old => DependencyInjector.error, :error => nil })
      end
      def method_missing(name, *arguments)
        #puts name
        #puts DependencyInjector.page_calls
      end
      DependencyInjector.set({ :page_calls => {} }) if !DependencyInjector.page_calls

      protected
      
      def call_by(method_name, *arguments)
        
        save_calls(self, method_name)
      end

      private

      def save_calls(klass, method)
        DependencyInjector.page_calls.merge!({method => klass})
      end
    end
  end
end
