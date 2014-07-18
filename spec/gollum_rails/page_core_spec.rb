require 'spec_helper'

describe GollumRails::Core do
  describe "Last changed by" do
    it "tests if the correct ammount of commits is in history" do
      commit1 = create(:gollum_page_spec)

      10.times do |page|
        commit1.update_attributes(name: "Page named: #{page}", commit: build(:commit_fakes)[:commit])
      end
      expect(commit1.last_changed_by) == "mosny11 <mosny@zyg.li>"
      commit1.destroy(build(:commit_fakes)[:commit])

    end

  end
  describe "#format_supported?(format)" do
    ['markdown',
     'rdoc',
     'org',
     'pod',
     'creole',
     'textile',
     'rest',
     'asciidoc',
     'mediawiki',
     'txt'
    ].each do |format|
      it "supports format #{format}" do
        expect(GollumRails::Page.format_supported?(format)) == true
      end
    end
  end

end
