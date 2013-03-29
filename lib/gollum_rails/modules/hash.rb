# See http://ruby-doc.org/core-2.0/Hash.html for further information
#
# Extended methods:
#   * object support
#   * setter
#   * hash setter
#   * isset
#
#
# TODO
#   * implement is? method
#   * improve testing
#
class ::Hash


  # Public: Converts a method . into an Hash element
  #
  # Examples
  #   hash = {a: "b", b: "c", c: "d"}   
  #   hash.a
  #   # => "b"
  #   #   hash.b
  #   # => "c"
  #
  # Returns an instance of Hash if the name is the key of a new hash
  def method_missing(name, *args)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end

end
