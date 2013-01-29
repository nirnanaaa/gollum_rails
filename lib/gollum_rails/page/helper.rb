module GollumRails
  class PageHelper
    class << self
      def method_missing(name, *arguments)
        #puts name
        puts arguments
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
