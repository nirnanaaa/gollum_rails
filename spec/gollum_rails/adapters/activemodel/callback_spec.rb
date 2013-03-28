require 'spec_helper'

describe GollumRails::Adapters::ActiveModel::Callback do
  before(:each) do
    @params = {:name => "mosny", :age => 11}
  end

  it "should test the callback initialization" do
    class Database < GollumRails::Adapters::ActiveModel::Callback
      
      attr_accessor :name,
                    :age

      def initialize(params = {})
        params.map{|k,v| self.instance_variable_set("@#{k}", v)}
      end
      def before_save
        @age.should == 11
        @name.should == "mosny"
      end
      def save
        %w[create save find update].each do |v|
          self.class.method_defined?("before_#{v}").should == true
          self.class.method_defined?("after_#{v}").should == true
        end
        run_callbacks :save              
      end
    end
    db = Database.new @params
    db.save
  end
end
