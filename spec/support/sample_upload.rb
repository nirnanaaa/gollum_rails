class SampleClassDefinitions < GollumRails::Upload
  max_filesize 2
  upload_directory 'uploads'
  overwrite_existing_files true
end
