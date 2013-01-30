module GollumRails
  require ::File.expand_path('../helper', __FILE__)
  ::Dir.glob(::File.expand_path(::File.dirname(__FILE__)) + '/*.rb') do |file|
    require file if file != __FILE__ and !file.include?("helper")
  end
end
