module Gollum
  module Rails
    class Page
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming
      attr_accessor :name, :content, :format, :commit
      
      attr_accessor :options
      
      attr_reader :wiki
      
      # attributes needs to be a hash
      # example:
      #   Gollum::Rails::Page.new({name: '', content: '', format: '', commit: {}})
      #
      #
      # explanation:
      # name must be a string.
      # content should be a text/String
      # format must be eighter :markdown, :latex, :rdoc, ...
      # commit must be a hash for example:
      #   commit = {
      #      message: 'page created',
      #      name: 'Florian Kasper',
      #      email: 'nirnanaaa@khnetworks.com'
      #   }
      def initialize(attributes, options = {})
        #options = self.class.options.merge
        attributes.each do |name, value|
          send("#{name}=", value)
        end
        
        #@wiki = Gollum::Rails::Wiki.getWiki
        #puts @wiki
        puts DependencyInjector.set("a","b")
        #@wiki = options.fetch :wiki, nil
      end
      def wikiLoaded?
        
      end
      # Some "ActiveRecord" like things e.g. .save .valid? .find .find_by_* .where and so on
      def save
      end
      def valid?
      end
      def find
      end
      def persisted?
        false
      end
      
    end
  end
end