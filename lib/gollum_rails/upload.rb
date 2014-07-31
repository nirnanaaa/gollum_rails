module GollumRails
  class Upload
    if ActiveModel::VERSION::MAJOR == 4
      include ActiveModel::Model
    else
      extend ActiveModel::Naming
      extend ActiveModel::Callbacks
      include ActiveModel::Conversion
      include ActiveModel::Validations
    end

    autoload :ClassDefinitions, 'gollum_rails/upload/class_definitions'
    autoload :FileTooBigError, 'gollum_rails/upload/file_too_big_error'
    autoload :BlacklistedFiletypeError, 'gollum_rails/upload/blacklisted_filetype_error'

    include Attributes
    include Store
    include ClassDefinitions

    attr_accessor :file
    attr_accessor :destination
    attr_accessor :commit
    attr_accessor :gollum_file

    def initialize(attrs)
      assign_attributes(attrs)
      yield self if block_given?
    end

    def save!
      if self.file
        fullname = Gollum::Page.cname(self.file.original_filename)
        tempfile = self.file
        validate! tempfile
      end

      @dir = self.destination || self.class.destination
      @fullname = fullname
      ext = ::File.extname(fullname)

      # Allowed formats in future
      format = ext.split('.').last || "txt"
      filename = ::File.basename(fullname, ext)
      contents = ::File.read(tempfile)
      options = self.commit
      committer = Gollum::Committer.new(self.class.wiki, options[:commit])
      committer.add_to_index(@dir, filename, format, contents)

      committer.commit
      _update_gollum_file(File.join(@dir,@fullname))
      self
    rescue Rugged::ReferenceError
      setup_branches
      retry
    end

    def save
      save!
    rescue Gollum::DuplicatePageError
      _update_gollum_file(File.join(@dir,@fullname))
      self
    rescue FileTooBigError => e
      @error = e.message
      self
    end

    def destroy(commit=nil)
      return false if !persisted?
      committer    = Gollum::Committer.new(self.class.wiki, commit||self.commit[:commit])
      committer.remove_from_index(self.gollum_file.path)
      sha = committer.commit
      _update_gollum_file(nil)
      sha
    end

    def self.create(attributes)
      self.new(attributes).save
    end

    def self.find(path)
      ins = self.new({})
      ins._update_gollum_file(path)
      ins
    end

    def persisted?
      !!self.gollum_file
    end

    def validate!(tempfile)
      if self.class.max_size
        raise FileTooBigError,
          "File is too big. Max. size is #{self.class.max_size}" if tempfile.size > self.class.max_size
      end
      ext = ::File.extname(tempfile.original_filename)
      type = (ext.split('.').last || "txt").to_sym
      if self.class.whitelist
        raise BlacklistedFiletypeError,
          "Filetype #{type} is blacklisted." unless self.class.whitelist.include?(type)
      end
      if self.class.blacklist
        raise BlacklistedFiletypeError,
          "Filetype #{type} is blacklisted." if self.class.blacklist.include?(type)
      end
    end

    def _find_gollum_file(path)
      wiki.file(path)
    end

    def _update_gollum_file(path)
      if path
        self.gollum_file = _find_gollum_file(path)
      else
        self.gollum_file = nil
      end
    end

    def to_s
      if @error
        "Error occured: <%s>" % @error
      else
        super
      end
    end

  end
end
