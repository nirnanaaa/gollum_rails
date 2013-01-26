module Gollum
  module Rails
    class Page
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend ActiveModel::Naming
      attr_accessor :name, :content, :format, :commit
      
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
      def initialize(attributes)
        attributes.each do |name, value|
          send("#{name}=", value)
        end
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