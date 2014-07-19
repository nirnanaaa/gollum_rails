
module GollumRails
  class Upload
    module ClassDefinitions
      extend ActiveSupport::Concern

      module ClassMethods
        attr_accessor :destination
        attr_accessor :overwrite
        attr_accessor :blacklist
        attr_accessor :whitelist
        def blacklist_format(*formats)
          self.blacklist ||= []
          self.blacklist += Array(formats)
        end
        def whitelist_format(*formats)
          self.whitelist ||= []
          self.whitelist += Array(formats)
        end
        def max_filesize(size)
          @max_size=size if size
        end
        def max_size
          @max_size
        end
        def upload_directory(dir)
          self.destination = dir
        end
        def overwrite_existing_files(bool)
          self.overwrite = bool
        end
      end
    end
  end
end
