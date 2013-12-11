module GollumRails
  module Store
    extend ActiveSupport::Concern
    # 
    # # Gets / Sets the pages name
    # attr_writer :name
    # 
    # # Gets / Sets the contents content
    # attr_writer :content
    # 
    # # Gets / Sets the commit Hash
    # attr_accessor :commit
    # 
    # # Sets the format
    # attr_writer :format
    
    ATTR_READERS = []
    ATTR_WRITERS = [:name, :content, :format]
    ATTR_ACCESSORS = [:commit, :gollum_page]
    
    included do
      ATTR_WRITERS.each do |a|
        attr_writer a
      end
      ATTR_ACCESSORS.each do |a|
        attr_accessor a
      end
      
    end
  end
end