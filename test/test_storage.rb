require File.expand_path(File.join(File.dirname(__FILE__), "helper"))
context "Backend" do
  include Rack::Test::Methods
  setup do
    @di_compo = Gollum::Rails::DependencyInjector
  end
  test "#simple holding test" do
    
    ##Boolean
    test_one = @di_compo.set("test1", false)
    assert_equal test_one, @di_compo.get("test1")
    assert_equal false, @di_compo.get("test1")
    
    ##Hash
    test_two = @di_compo.set("test2", Hash.new)
    assert_equal test_two, @di_compo.get("test2")
    assert_instance_of Hash, @di_compo.get("test2")
    
    ##Wiki Class
    test_three = @di_compo.set("test3", Gollum::Rails::Wiki.new(PATH))
    assert_equal test_three, @di_compo.get("test3")
    assert_instance_of Gollum::Rails::Wiki, test_three
    assert_instance_of Gollum::Rails::Wiki, @di_compo.get("test3")
    
    ##integer
    r = Random.new
    rand = r.rand(10000..420000)
    describe = r.rand(10000..420000)
    test_four = @di_compo.set(describe, rand)
    assert_equal rand, @di_compo.get(describe)
    assert_instance_of Fixnum, @di_compo.get(describe)
    
  end
end
