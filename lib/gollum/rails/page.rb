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
        if !Validations.is_boolean?(@persisted)
          @persisted = false
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
        if valid?
          begin
            @wiki.wiki.write_page(@name, @format, @content, @commit)
          end
        end
      end

      def update
      end
      
      ## if a page is loaded
      def get_raw_data
        
      end
      def version
        
      end
      def get_formatted_data
        
      end

      # default:
      #  - name must be set
      #  - content can be NIL || " "
      #  - committer must be set
      # format must be set
      def valid?
        if !@name || @name.nil?
          return false
        end
        if !@commit || !@commit.is_a?(Hash)
          return false
        end
        if !@format
          return false
        end
        return true
        
      end

      def find(by_string = nil)
        if !by_string.nil?

        end
      end

      def persisted?
        @persisted
      end

      def method_missing(name, *args)

      end

    end
  end
end