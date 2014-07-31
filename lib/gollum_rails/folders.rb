module GollumRails
  class Folders
    attr_accessor :base
    attr_accessor :name
    attr_accessor :path
    attr_accessor :sha

    def initialize
      @base = Page.wiki.page_file_dir
    end

    def strip(blob)
      @sha = blob.sha
      path = blob.path.gsub(/^#{@base}/,'')
      path.gsub!(/^\/+/,'')
      path.gsub!(/\/(.*)/,'')
      if ::File.extname(path).empty?
        @name = path
        @path = path
      end
      self
    end

    def inspect
      "<GollumRails::Folders #{name}>"
    end
  end
end
