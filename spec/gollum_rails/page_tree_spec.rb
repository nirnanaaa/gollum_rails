require 'spec_helper'

describe "Page tree spec" do
  before :each do

  end
  it "prints out the content of the root directory"do
    n1 = create(:gollum_page_spec, name: 'ab/c')
    n2 = create(:gollum_page_spec, name: 'ab/d')
    n3 = create(:gollum_page_spec, name: 'cde')
    tree = GollumRails::Page.tree
    puts tree.inspect
    expect(tree.length).to be 2
    n1.destroy
    n2.destroy
    n3.destroy
  end
  it "prints out the content of a sub directory" do

  end
  it "prints out the content of deep sub directories" do

  end
  it "prints out if the folder given is empty" do

  end
end
