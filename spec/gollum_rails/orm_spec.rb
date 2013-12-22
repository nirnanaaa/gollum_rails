require 'spec_helper'


describe GollumRails::Orm do
  let(:commit){{
        name: "flo",
        message: "commit",
        email: "mosny@zyg.li"}}
  let(:pageattrs){{
        name: "Pagetester",
        content: "content data",
        commit: commit,
        format: :markdown}}
  class PTest < GollumRails::Page
    include GollumRails::Orm
  end
  # before(:each){@rr = PTest.create(pageattrs)}
  # after(:each){}

  it "should alias the all function" do
    @rr = PTest.new(pageattrs)
    #expect(PTest).to respond_to(:all_pages)
    #@rr.destroy(commit)
  end
end