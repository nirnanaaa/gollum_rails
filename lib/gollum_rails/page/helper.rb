module GollumRails

  # Public: No commit is given in action
  class CommitMustBeGivenError < StandardError; end

  # Public: No page was loaded / found (instead of nil)
  class NoPageLoadedError < StandardError; end

  # Public: Module internal error / not loaded
  class ModuleInternalError < StandardError; end

  # Public: Page helpers, to include if writing an extension for the Page class
  #
  class PageHelper
    class << self

      # Public: will be called from child functions if called
      # Half transparent
      #
      # Examples
      #   Page.find("some string")
      #   # method will be called in background
      #   # => nil || Gollum::Page
      #
      # Returns a Hash
      def initialized_first
        DependencyInjector.set({:error_old => []}) if not DependencyInjector.error_old.is_a?(Array)
        DependencyInjector.error_old <<  DependencyInjector.error if DependencyInjector.error_old.is_a?(Array)
        DependencyInjector.set({
          :error => nil
        })
      end

      # Public: catches method missings / will soft fail
      #
      # name - methods Name
      # arguments - Array containing all arguments, the function was called with
      #
      # Examples
      #   Find.do_something_strange
      #   # => MethodMissing
      def method_missing(name, *arguments)
        DependencyInjector.set({ :error => "No such method \n\ncall:\n\t#{name}\n\t#{arguments}"})
      end

      # Public: sets the DI page_calls to a new Hash ( FIXME )
      DependencyInjector.set({ :page_calls => {} }) if !DependencyInjector.page_calls


      protected

      # Public: Injector block
      #
      # Injects a codeblock into an Object
      #
      # object - Object, to inject in
      # block - Code block to inject
      #
      # Examples
      #
      #   inject_on_startup Gollum::Page do
      #     def delete(commit)
      #       delete_page(<page>, commit)
      #     end
      #   end
      #
      def inject_on_startup(object, &block)
        object.instance_eval(&block)
      end

      # Public: Registers a call under method_name in Page class
      #
      # method_name - the method to be run on
      #
      # Examples
      #   class Abc
      #     call_by 'find'
      #     # or :find
      #   end
      #
      # Returns a Hash from DI component
      def call_by(method_name)
        return save_calls(self, method_name)
      end

      private

      # Public: Saves the current call_by call
      def save_calls(klass, method)
        Page.class.instance_eval do
          define_method(method) do |*argv|
            klass.initialized_first
            return klass.single_run(*argv)
          end
        end
        DependencyInjector.page_calls.merge!({method => klass})

      end
    end
  end
end
