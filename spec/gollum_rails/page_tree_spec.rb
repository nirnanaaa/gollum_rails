require 'spec_helper'

describe "Page tree spec" do
  before :each do

  end
  it "prints out the content of the root directory"do
    n1 = create(:gollum_page_spec, name: 'ab/c')
    n2 = create(:gollum_page_spec, name: 'ab/d')
    n3 = create(:gollum_page_spec, name: 'cde')
    tree = GollumRails::Page.tree
    expect(tree.length).to be 2
    n1.destroy
    n2.destroy
    n3.destroy
  end
  describe "directory ab" do
    before :suite do
      @n1 = create(:gollum_page_spec, name: 'ab/c')
      @n2 = create(:gollum_page_spec, name: 'ab/d')
      @n3 = create(:gollum_page_spec, name: 'ab/e')
    end
    after :suite do
      @n1.destroy
      @n2.destroy
      @n3.destroy
    end
    it "prints out the content of a sub directory" do
      len = GollumRails::Page.tree(folder: 'ab')
      expect(len.length).to be 3
    end
    it "has all pages in folder ab" do
      len = GollumRails::Page.tree(folder: 'ab')
      len.each do |file|
        expect(file.path).to match('ab')
      end
    end
    it "is an empty array if the folder is empty" do
      len = GollumRails::Page.tree(folder: 'abc')
      expect(len.length).to be 0
    end
  end

  it "prints out the content of deep sub directories" do

  end
end
