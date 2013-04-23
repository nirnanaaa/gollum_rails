require 'spec_helper'

describe "Gollum Page" do
  before(:each) do
      @commit = {
        :name => "flo",
        :message => "commit",
        :email => "mosny@zyg.li"
      }
      @call = {
        :name => "Goole",
        :content => "content data",
        :commit => @commit,
        :format => :markdown
      }
    end
  describe GollumRails::Page do
    class RailsModel < GollumRails::Page


    end

    it "should test the creation of a page" do
      rr = RailsModel.new(@call)
      rr.save.should be_instance_of Gollum::Page
      rr.save!.should be_instance_of Gollum::Page
      RailsModel.create(@call)
    end

    it "should test the update of a page" do
      rr = RailsModel.new @call
      cc = rr.save.should be_instance_of Gollum::Page
      rr.update_attributes({:name => "google", :format => :wiki}).should be_instance_of Gollum::Page
    end

    it "should test the deletion of a page" do
      rr = RailsModel.new @call
      cc = rr.save.should be_instance_of Gollum::Page
      rr.delete.should be_instance_of String
    end

    it "should test the finding of a page" do
      RailsModel.find('google').should be_instance_of Gollum::Page

      #invalid input
      RailsModel.find('<script type="text/javascript">alert(123);</script>').should be_nil
    end
    it "should test the preview" do
      rr = RailsModel.new :content => "# content", :name => "somepage"
      100.times do
        rr.preview.should include("<h1>content<a class=\"anchor\" id=\"content\" href=\"#content\"></a></h1>")
      end
    end

    it "should test exception methods" do
      create = RailsModel.create! @call
    end

    it "should test the supported formats" do
      RailsModel.format_supported?('ascii').should be_true
      RailsModel.format_supported?('markdown').should be_true
      RailsModel.format_supported?('github-markdown').should be_true
      RailsModel.format_supported?('rdoc').should be_true
      RailsModel.format_supported?('org').should be_true
      RailsModel.format_supported?('pod').should be_true
    end

    it "should test getters" do
      rr = RailsModel.new @call
      rr.name.should == "Goole"
      rr.content.should == "content data"
      rr.commit.should be_instance_of Hash
      rr.commit.should == @commit
      rr.format.should == :markdown
      rr.save
      rr.page.should be_instance_of GollumRails::Adapters::Gollum::Page
    end
    it "should test setters" do
      rr = RailsModel.new
      rr.name=("google").should == "google"
      rr.commit=(@commit).should == @commit
      rr.content=("content").should == "content"
      rr.format=(:markdown).should == :markdown
    end


    it "should test find or initialize" do
      rr = RailsModel.new @call
      rr.save
      RailsModel.find_or_initialize_by_name(@call[:name], @commit).should  be_instance_of Gollum::Page
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
      test.delete @commit
      test.save
      test.update_attributes @call
      test.persisted?.should be_true
    end
  end
  describe "rails extension" do
    it "should test fetch_all" do
      GollumRails::Page.all.length.should == 2
      GollumRails::Page.find_all.length.should == 2
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
 describe "the thread safety" do
   class ThreadModel < GollumRails::Page

   end
   it "should save " do
     100.times do |time|
       Thread.new do
         ThreadModel.new(@call)
         ThreadModel.save.should be_instance_of(Gollum::Page)
         ThreadModel.delete(@commit).length.should == 40
       end
     end

   end


end
end
