
module GollumRails
  class Upload
    module ClassDefinitions
      extend ActiveSupport::Concern

      module ClassMethods
        attr_accessor :destination
        attr_accessor :overwrite
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
