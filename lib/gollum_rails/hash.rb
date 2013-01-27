# Public: Extend Hash class by a method missing call
class ::Hash
  
  # Public: Converts a method . into an Hash element
  #
  # Examples
  #   hash = {a: "b", b: "c", c: "d"}   
  #   hash.a
  #   # => "b"
  #   hash.b
  #   # => "c"
  #
  # Returns an instance of Hash if the name is the key of a new hash
  #         otherwise it will return the value of the key 
  def method_missing(name)
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end
end
