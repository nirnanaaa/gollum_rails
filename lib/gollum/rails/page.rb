module Gollum
  module Rails
    class Page
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming
      
      attr_accessor :name
      
      attr_accessor :content
      
      attr_accessor :format
      
      attr_accessor :commit
      
      attr_accessor :options
      
      attr_reader :wiki
      
      attr_reader :persisted
      
      
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
        wiki = DependencyInjector.get('wiki')
        if wiki && wiki.is_a?(Wiki)
          @wiki = wiki
        end
        
        attributes.each do |name, value|
          send("#{name}=", value)
        end
        
      end
      ## checks if @wiki.wiki is an instance of Gollum::Wiki
      def wikiLoaded?
        @wiki.wiki.is_a?(Gollum::Wiki)
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