module GollumRails
  ::Dir.glob(::File.expand_path(::File.dirname(__FILE__)) + '/*.rb') do |file|
    require file if file != __FILE__
  end
end
