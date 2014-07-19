class SampleClassDefinitions < GollumRails::Upload
  max_filesize 2
  upload_directory 'uploads'
  overwrite_existing_files true
end

class SampleUploadBlacklistPng < GollumRails::Upload
  blacklist_format :png
end

class SampleUploadWhitelistPng < GollumRails::Upload
  whitelist_format :png
end
