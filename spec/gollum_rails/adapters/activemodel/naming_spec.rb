require 'spec_helper'

describe GollumRails::Adapters::ActiveModel::Naming do
  include GollumRails::Adapters::ActiveModel::Naming

  before(:each) do
    @model = GollumRails::Adapters::ActiveModel::Naming
  end

  it "should use _scores" do
    class Blax < GollumRails::Adapters::ActiveModel::Naming::NameSpace
      include GollumRails::Adapters::ActiveModel::Naming

      def initialize
        class_name.should == self.class.name
        class_name.should == "Blax"
        plural_filename_for_class(Blax).should == "blaxes"
        singular_filename_for_class(Blax).should == "blax"

      end

    end

    bla = Blax.new

  end
end
