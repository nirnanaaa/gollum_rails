module GollumRails
  class Item
    attr_reader :type
    attr_reader :name
    attr_reader :path

    def initialize(item)
      dir = Page.wiki.page_file_dir
      if dir && !dir.empty?
        regex = /^#{dir}\/(.*[\/])/
      else
        regex = /^(.*[\/])/
      end
      if item.path !~ regex
        @type = :file
      end
      if item.path =~ regex
        require 'gollum_rails/folders'
        @type = :folder
        item = Folders.new.strip(item)
      end

      base = Page.wiki.page_file_dir

      if base && !base.empty?
        @path = File.join(base,item.path)
      else
        @path = item.path
      end

      @name = item.name
    end
    def inspect
      "#<GollumRails::Item type=#{(@type==:folder)? 'Folder' : 'File'} path=#{@path}>"
    end
  end
end
