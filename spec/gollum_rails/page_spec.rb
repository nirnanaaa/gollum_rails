require 'spec_helper'
describe "Gollum Page" do
  before(:each) do
    GollumRails::Setup.build do |config|
      config.repository = File.join(File.dirname(__FILE__),'..','utils','wiki.git')
      config.options={}
      config.startup = true
    end
      @commit = {
        name: "flo",
        message: "commit",
        email: "mosny@zyg.li"
      }
      @call = {
        name: "Goole",
        content: "content data",
        commit: @commit,
        format: :markdown
      }
    end
  describe GollumRails::Page do
    class RailsModel < GollumRails::Page; end
    describe "the creation of a page" do
      before :each do
        @rr = RailsModel.new(@call)
      end
      it "saves via .save" do
        expect(@rr.save).to be_a GollumRails::Page
      end
      it "saves via .create" do
        expect(RailsModel.create(@call)).to be_a GollumRails::Page
      end
      it "fails if invalid arguments are supplied via the ! create" do
        args = {
          name: "Gaming",
          content: "content data",
          commit: {},
          format: :markdown
        }
        expect{RailsModel.create!(args)}.to raise_error  StandardError #change this
      end
      it "has a history now" do
        @rr.save
        expect(@rr.history).to be_a Array
      end
      it "outputs the raw_data" do
        @rr.save
        expect(@rr.raw_data) == @call[:content]
      end
      it "has the formatted data" do
        @rr.save
        expect(@rr.html_data) == '<p>content data</p>'
      end
      it "can be saved using special characters in name" do
        @rr.name = 'test-page'
        @rr.save
        expect(RailsModel.find('test-page')).not_to be_nil
        @rr.destroy
      end
      it "has a cname" do
        @rr.name = 'test page'
        @rr.save
        expect(@rr.cname).to match('test-page')
        @rr.destroy
      end
      it "has a filename " do
       @rr.name = '/home/page/test/page'
       @rr.save
       expect(@rr.file_name).to match 'page'
       @rr.destroy
      end
      it "has a title" do
        @rr.save
        expect(@rr.title) == "Goole"
      end
      it "has a url" do
        @rr.save
        expect(@rr.url) =="Goole"
      end
    end
    describe "the update of a page" do
      before :each do
        @rr = RailsModel.new(@call)
        @rr.save
      end
      it "updates properly without all arguments, content+commit" do
        expect(@rr.update_attributes({:name => "google", :format => :wiki})).to be_a GollumRails::Page
        @rr.delete(@commit)
      end
      it "sets the format as created" do
        @rr.update_attributes(name: "omg", format: :textile)
        expect(@rr.format).to eq :textile
        @rr.delete(@commit)
      end
      it "sets the name as created" do
        @rr.update_attributes(name: "omg", format: :textile)
        expect(@rr.name).to eq "omg"
        @rr.delete(@commit)
      end
      it "updates properly without all arguments, name, format" do
        expect(@rr.update_attributes({:content => "test"})).to be_a GollumRails::Page
        expect(@rr.name).to match "Goole"
        expect(@rr.format.to_s).to match "markdown"
        @rr.delete(@commit)
      end
    end
    describe "should test the deletion of a page" do
      before :each do
        @rr = RailsModel.new @call
        @cc = @rr.save
      end
      it "should return a string" do
        delete = @rr.delete
        expect(delete).to be_a String
      end
      it "should return a SHA1 hash" do
        delete = @rr.delete
        expect(delete.length) == 40
      end
      it "should also work was result from save" do
        delete = @cc.delete
        expect(delete).to be_a String
      end
    end
    it "should test exception methods" do
      RailsModel.create @call
      expect{RailsModel.create! @call}.to raise_error Gollum::DuplicatePageError
    end
    describe "supported formats" do
      ['markdown', 'rdoc', 'org', 'pod'].each do |format|
        it "should support #{format}" do
          expect(RailsModel.format_supported?(format))== true
        end
      end
    end
    describe "accessors" do
      let(:rr){RailsModel.new @call}
      it "should have a name" do
        expect(rr.name).to match(/^Goole$/)
      end
      it "should have a preview" do
        expect(rr.preview).to match(/content/)
      end
      it "should have a content" do
        expect(rr.content).to match(/^content\ data$/)
      end
      it "should have a commit which is a Hash" do
        expect(rr.commit).to be_a Hash
      end
      it "should be @commit" do
        expect(rr.commit).to be(@commit)
      end
      it "should have a format" do
        expect(rr.format.to_s).to match('markdown')
      end
      it "should be a Gollum::Page after save" do
        rr.save
        expect(rr.gollum_page).to be_a Gollum::Page
      end
    end
    it "should test setters" do
      rr = RailsModel.new
      expect(rr.name=("google")) == "google"
      expect(rr.commit=(@commit)) == @commit
      expect(rr.content=("content")) == "content"
      expect(rr.format=(:markdown)) == :markdown
    end
    it "gets the pages filename on disk with a 'DOT' in filename" do
      expect(RailsModel.find('Goole').filename).to match('.')
    end
    it "gets the pages filename on disk withOUT a 'dot' in filename" do
      expect(RailsModel.find('Goole').filename(false)).not_to match('.md')
    end
    it "tests the find method to return nil if no page was found" do
      expect(RailsModel.find('whoooohoo')).to be_nil
    end
    it "should initializes all with GollumRails::Page" do
      expect(RailsModel.all.first).to be_kind_of GollumRails::Page
    end
    it "should have a gollum page after initializing with all" do
      expect(RailsModel.all.first.gollum_page).not_to be_nil
    end
    it "tests the find method to return a gollum_rails:page if a page was found" do
      expect(RailsModel.find('Goole')).to be_a GollumRails::Page
    end
    it 'should not be persisted on initialization or finding' do
      init = RailsModel.find_or_initialize_by_name('totallybad', @commit)
      expect(init.persisted?) == false
    end
    it "should find the page without a commit if it exists" do
      expect(RailsModel.find_or_initialize_by_name("Goole").persisted?)== true
    end
    it "should find the page with a commit if it exists" do
      expect(RailsModel.find_or_initialize_by_name("Goole", @commit).persisted?)== true
    end
    it "should be valid on initialization or finding" do
      init = RailsModel.find_or_initialize_by_name('whoooohooo', @commit)
      expect(init.valid?)== true
      #RailsModel.find_or_initialize_by_name(@call[:name], @commit)).to  be_a GollumRails::Page
    end
  end
  describe "callback testing" do

    # Callback class definition
    class SaveCallbacks < GollumRails::Page
      after_save :after_save

      before_destroy :before_delete

      before_update :before_update
      after_update :after_update
      def after_save; end
      def before_delete; end
      def before_update; end
      def after_update; end
    end
    let(:cls) { SaveCallbacks.new(@call) }
    after(:each) do
      cls.destroy(@commit)
    end

    it "receives the after_save callback" do
      expect(cls).to receive(:after_save)
      cls.save
    end
    it "receives the before_delete callback" do
      expect(cls).to receive(:before_delete)
    end
    it "receives the after_update callback" do
      expect(cls).to receive(:after_update)
      cls.save
      cls.update_attributes(name: "Somepage")
    end
    it "receives the before_update callback" do
      expect(cls).to receive(:before_update)
      cls.save
      cls.update_attributes(name: "Somepage")
    end

  end
  describe "testing validation" do
   it "should test the basic validation" do
     class Callbackt < GollumRails::Page
      validates_presence_of :name
     end
     cla = Callbackt.new @call
     expect(cla.valid?)== true
   end
   class SugarBaby < GollumRails::Page
     validates_presence_of :name
     validates_length_of :name, :minimum => 20
     validates_length_of :format, :maximum => 14
   end
   it "should test string validation" do
     @call[:name] = "das ist zu lang"*10
     cla = SugarBaby.new @call
     expect(cla.valid?)== true
   end
   it "should test the presence validator" do
     @call[:name] = [ ]
     bla = SugarBaby.new @call
     expect(bla.valid?) == false
   end
   it "should test the length validator for name" do
     @call[:name] = "das"
     res = SugarBaby.new @call
     expect(res.valid?) == false
   end
   it "should test the length validator for format" do
     @call[:format] = :toolongformatstringforvalidator
     res = SugarBaby.new @call
     expect(res.valid?) == false
   end
  end
  describe "diffing commits" do
    class CommitDiff < GollumRails::Page
    end
    it "should display the diff commit" do
      commit = {
        name: "flo",
        message: "commit",
        email: "mosny@zyg.li"
      }
      call = {
        name: "aPage",
        content: "my content",
        commit: commit,
        format: :markdown
      }
      res = CommitDiff.new call
      res.save
      diff = res.compare_commits(res.history.first)
      expect(diff).to be_a String
      expect(diff).to match(/---/)
      res.delete
    end
  end
  describe "Sub Page" do
    class Fns < GollumRails::Page
    end
    it "should return nil if not persisted" do
      res = CommitDiff.new @call
      expect(res.sub_page?).to be_nil
    end
    it "should be true" do
      res = CommitDiff.new @call.merge(name: '_aPage')
      res.save
      expect(res.sub_page?)== true
      res.delete
    end
    it "should be false" do
      res = CommitDiff.new @call
      res.save
      expect(res.sub_page?) == false
      res.delete
    end
  end
  describe "Current version" do
    class Fns < GollumRails::Page
    end
    it "current version should have 7 digest" do
      res = CommitDiff.new @call
      res.save
      expect(res.current_version.length).to be(7)
      res.delete
    end
    it "should be nil if page has not been set" do
      res = CommitDiff.new @call
      expect(res.current_version).to be_nil
    end
    it "should be the latest version of the page but shortened" do
      res = CommitDiff.new @call
      res.save
      expect(res.gollum_page.version.to_s).to match(res.current_version)
      res.delete
    end
    it "should display the long version" do
      res = CommitDiff.new @call
      res.save
      expect(res.gollum_page.version.to_s).to match(/^#{res.current_version(true)}$/)
      res.delete
    end
  end
  describe 'History' do
    class Fns < GollumRails::Page
    end
    it "history should return nil if no gollum_page was saved" do
      res = Fns.new @call
      expect(res.history).to be_nil
    end
    it "history should return the pages versions if there are changes" do
      res = Fns.new @call
      res.save
      expect(res.history).to be_a Array
      res.delete
    end
  end
  describe "path names" do
    class Fns < GollumRails::Page
    end
    it "should output nothing as there is no path" do
      res = Fns.create @call
      expect(res.path_name).to match ''
      res.destroy(@commit)
    end
    it "should output a path name as there was a path supplied" do
      res = Fns.new @call.merge(name: 'test/pagess')
      res.save
      res2 = Fns.new @call.merge(name: 'test/pagess2')
      res2.save
      expect(Fns.all(folder: 'test').length).to be 2
      #expect(res.path_name).not_to be_nil
      res2.destroy(@commit)
      res.destroy(@commit)
    end
    it "should find more pages under root without options" do
      res = Fns.new @call.merge(name: 'test4/pagess')
      res2 = Fns.new @call.merge(name: 'test5/pagess')
      res.save
      res2.save
      #Fns.all(folder: 'test1/').each{|p| puts p.url}
      expect(Fns.all(folder: 'test4').length).to be 1
      expect(Fns.all(folder: 'test5').length).to be 1
      res2.destroy(@commit)
      res.destroy(@commit)
    end
    it "should be empty for a non existing folder" do
      res = Fns.new @call.merge(name: 'test/pagess')
      res.save
      expect(Fns.first(folder: 'test2')).to be_nil
      expect(Fns.last(folder: 'test2')).to be_nil
      res.destroy(@commit)
    end
    it "should not be empty for an existing folder" do
      res = Fns.new @call.merge(name: 'test/pagess')
      res.save
      expect(Fns.first(folder: 'test')).not_to be_nil
      expect(Fns.last(folder: 'test')).not_to be_nil
      res.destroy(@commit)
    end
    it "should change the folder" do
      res = Fns.new @call.merge(name: 'test/pagess')
      res.save
      expect(res.path_name).not_to be_nil
      res.destroy(@commit)
    end
    it "should create a nested page under /test" do
      res = Fns.new @call.merge(name: 'test/my_page')
      res.save
      expect(res.url_path).to include 'test'
      res.destroy(@commit)
    end
    it "should find a nested file" do
      res = Fns.new @call.merge(name: 'test/my_page2')
      res.save
      expect(Fns.find('test/my_page2')).not_to be_nil
      res.destroy
    end
    it "should search for a files content" do
      res = Fns.new @call.merge(name: 'test/my_page3')
      res.save
      expect(Fns.search('content')).not_to be_empty
      expect(Fns.search('content').length).to be >= 1
      res.destroy
    end
  end
#end
end
