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
    return set(name, args) if name =~ /\=$/
    return is?(name, args) if name =~ /\?$/
    return self[name] if key? name
    self.each { |k,v| return v if k.to_s.to_sym == name }
    super.method_missing name
  end

  # Sets the name variable with given args
  #
  # name - Hash label
  # arg - Value to bind to
  # Returns either true or false
  def set(name, arg)
    new = name.to_s.gsub(/\=/, '')
    self[new.to_sym] = arg[0].to_s
  end
  alias_method :set_argument, :set

  # Overwrites Hash content
  #
  # convertes no hash data to hash
  def set_new(*args)
    args = Hash[*args]
    args.map { |k,v| self[k.to_sym] = v }
  end

  alias_method :hash=, :set_new

  # Checks if Hash is set
  #
  # Returns a boolean
  def is?(name, *args)
    new = name.to_s.gsub(/\?/, '')
  end

end
