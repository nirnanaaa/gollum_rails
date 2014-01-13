module GollumRails
  module Store
    extend ActiveSupport::Concern

    
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
    
    module ClassMethods
      # Gets the wiki instance
      def wiki
        @wiki ||= Gollum::Wiki.new(Setup.wiki_path, Setup.wiki_options)
      end
    end
    # Gets the pages format
    def format
      (@format || @gollum_page.format).to_sym
    end

    def name
      @name ||= @gollum_page.name
    end
    
    # == Outputs the pages filename on disc
    #
    # ext - Wether to output extension or not
    def filename(ext=true)
      @filename ||= (ext) ? @gollum_page.filename : @gollum_page.filename_stripped
    end
    
    def content
      @content ||= @gollum_page.content
    end

    # Gets the page class
    def page
      Adapters::Gollum::Page.new
    end
    
    private 
    # == To static
    def wiki
      self.class.wiki
    end
    
    
    
  end
end