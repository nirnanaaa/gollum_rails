module GollumRails
  class PageHelper
    class << self

     def method_missing(name, *arguments)

      end
      if !DependencyInjector.page_attributes
        eval "DependencyInjector.set({ :page_attributes =>{} })"
      end

      protected

      def call_by(name, *arguments)
        DependencyInjector.set(DependencyInjector.page_attributes.merge!({
           self.name => {:call => {:by =>name, :arguments => arguments}}}))
      end

      def attribute(name, *arguments)
        if !DependencyInjector.send("page_attributes")
          DependencyInjector.set({ :page_attributes =>{} })
        end
        depi = DependencyInjector.page_attributes # {}
        nary = { self.name.merge!({ :arguments => {  name =>{ :arguments => arguments}}})}
        depi.merge!(nary)
        DependencyInjector.set({:page_attributes => depi})
        puts DependencyInjector.page_attributes
        #puts GollumRails::DependencyInjector.send("page_attrib.#{name}")

        if DependencyInjector.send("page_attrib_#{name}")
          #puts DependencyInjecor.instance_variable_get("page_attrib_#{name}")
          #puts DependencyInjector.send("page_attrib_#{name}")
          #puts "bla"
        end
      end

    end
  end
end
