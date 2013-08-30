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
        @rr.save.should be_a GollumRails::Page
      end
      

      it "saves via .create" do
        RailsModel.create(@call).should be_a GollumRails::Page
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
        @rr.history.should be_a Array
      end
      it "outputs the raw_data" do
        @rr.save
        @rr.raw_data.should == @call[:content]
      end
      it "has the formatted data" do
        @rr.save
        @rr.html_data.should == '<p>content data</p>'
      end
      it "was last changed by me" do
        @rr.save
        @rr.last_changed_by.should == 'flo <mosny@zyg.li>'
      end
      it "has a title" do
        @rr.save
        @rr.title.should == "Goole"
      end
      it "has a url" do
        @rr.save
        @rr.url.should =="Goole"
      end

    end

    describe "the update of a page" do
      before :each do 
        @rr = RailsModel.new(@call)
        @rr.save
      end
      
      it { @rr.update_attributes({:name => "google", :format => :wiki}).should be_a Gollum::Page }
      
    end
    describe "method missings" do
      
      it "should perform a normal find" do
        RailsModel.find_by_name('Goole').should be_a GollumRails::Page
          
        
      end
      
    end

    describe "should test the deletion of a page" do
      before :each do 
        @rr = RailsModel.new @call
        @cc = @rr.save
      end
      
      it "should return a string" do
        delete = @rr.delete
        delete.should be_a String
      end
      
      it "should return a SHA1 hash" do
        delete = @rr.delete
        delete.length.should == 40
      end
      
      it "should also work was result from save" do
        delete = @cc.delete
        delete.should be_a String
      end
      
      it "should test the recreation" do
        delete = @rr.delete
        @rr.save.should be_a GollumRails::Page
        @rr.delete.should be_a String
        
      end
    end


    100.times do
      it "should test the preview" do
        rr = RailsModel.new :content => "# content", :name => "somepage"
          rr.preview.should include("<h1>content<a class=\"anchor\" id=\"content\" href=\"#content\"></a></h1>")
      end
   end
   
    it "should test exception methods" do
      RailsModel.create @call
      expect{RailsModel.create! @call}.to raise_error Gollum::DuplicatePageError
    end

    describe "supported formats" do
      ['markdown', 'rdoc', 'org', 'pod'].each do |format|
        it "should support #{format}" do
          RailsModel.format_supported?(format).should be_true
        end
      end
      
    end
    
    describe "accessors" do
      let(:rr){RailsModel.new @call}
      
      it "should have a name" do
        expect(rr.name).to match(/^Goole$/)
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
      rr.name=("google").should == "google"
      rr.commit=(@commit).should == @commit
      rr.content=("content").should == "content"
      rr.format=(:markdown).should == :markdown
    end
    
    it "tests the find method to return nil if no page was found" do
      expect(RailsModel.find('whoooohoo')).to be_nil
    end
    
    it "tests the find method to return a gollum_rails:page if a page was found" do
      expect(RailsModel.find('Goole')).to be_a GollumRails::Page
    end
    
    it 'should not be persisted on initialization or finding' do
      init = RailsModel.find_or_initialize_by_name('totallybad', @commit)
      expect(init.persisted?).to be_false
    end
    
    it "should find the page without a commit if it exists" do
      expect(RailsModel.find_or_initialize_by_name("Goole").persisted?).to be_true
    end
    
    it "should find the page with a commit if it exists" do
      expect(RailsModel.find_or_initialize_by_name("Goole", @commit).persisted?).to be_true
    end
    
    it "should be valid on initialization or finding" do
      init = RailsModel.find_or_initialize_by_name('whoooohooo', @commit)
      expect(init.valid?).to be_true
      
      #RailsModel.find_or_initialize_by_name(@call[:name], @commit).should  be_a GollumRails::Page
      
    end
  end
  describe "callbacks" do



    it "should test the callback functions" do

      class SaveCallback
        def self.before_save( obj )
          obj.name.should == "Goole"
        end
      end


      class CallbackTest < GollumRails::Page

        before_save ::SaveCallback
        after_save :after_save
        after_delete :after_delete
        before_delete :before_delete
        before_update :before_update
        after_update :after_update

        def after_save
          @name.should == "Goole"
        end
        def before_update
          @name.should == "Goole"
        end

        def after_update
          @name.should == "Goole"
        end

        def before_delete
          @name.should == "Goole"
        end

        def after_delete
          @name.should == "Goole"
        end

      end

      test = CallbackTest.new @call
      test.persisted?.should be_false
      test.save
    end
  end
  describe "rails extension" do
    
    it "should test fetch_all" do
      GollumRails::Page.all.length.should == 1
    end
    it "should test all" do 
      GollumRails::Page.find_all.length.should == 1
    end

  end
  describe "testing validation" do



   it "should test the basic validation" do
     class Callbackt < GollumRails::Page
      validates_presence_of :name
     end
     
     cla = Callbackt.new @call
     cla.valid?.should be_true
   end
   
   class SugarBaby < GollumRails::Page
     validates_presence_of :name
     validates_length_of :name, :minimum => 20
     validates_length_of :format, :maximum => 14
   end
   
   it "should test string validation" do
     @call[:name] = "das ist zu lang"*10
     cla = SugarBaby.new @call
     cla.valid?.should be_true
   end
   
   it "should test the presence validator" do
     @call[:name] = [ ]
     bla = SugarBaby.new @call
     bla.valid?.should be_false
   end
   
   it "should test the length validator for name" do
     @call[:name] = "das"
     res = SugarBaby.new @call
     res.valid?.should be_false
   end
   
   it "should test the length validator for format" do
     @call[:format] = :toolongformatstringforvalidator
     res = SugarBaby.new @call
     res.valid?.should be_false
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
        name: "a Page",
        content: "my content",
        commit: commit,
        format: :markdown
      }
      
      res = CommitDiff.new call
      res.save
      res.update_attributes("content",nil,:markdown, @commit)
      diff = res.compare_commits(res.history.first)
      expect(diff).to be_a String
      expect(diff).to match(/diff/)
      res.delete
    end
    
  end
  
  describe "Filename" do
    class Fns < GollumRails::Page
    end
    it "should assemble a filename" do
      res = CommitDiff.new @call
      expect(res.filename).to match(/^Goole\.md$/)
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
      expect(res.sub_page?).to be_true
      res.delete
    end
    
    it "should be false" do
      res = CommitDiff.new @call
      res.save
      expect(res.sub_page?).to be_false
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
  
 # describe "the thread safety" do
#    class ThreadModel < GollumRails::Page
# 
#    end
#    it "should save " do
#      100.times do |time|
#        Thread.new do
#          ThreadModel.new(@call)
#          ThreadModel.save.should be_a(GollumRails::Page)
#          ThreadModel.delete(@commit).length.should == 40
#        end
#      end
# 
#    end


#end
end
