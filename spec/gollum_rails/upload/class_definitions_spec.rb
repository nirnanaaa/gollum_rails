require 'spec_helper'
require 'active_support/core_ext/numeric'
require 'active_support/core_ext/module/attribute_accessors'

describe GollumRails::Upload::ClassDefinitions do


  it "has a max filesize defined" do
    expect(SampleClassDefinitions.max_size).to eq 2.bytes
  end
  it "has a upload directory defined" do
    expect(SampleClassDefinitions.destination).to eq 'uploads'
  end
  it "overwrites existing files" do
    expect(SampleClassDefinitions.overwrite) == true
  end
  describe "validation" do
    let(:ins){build(:restrictions_upload)}
    let(:ins2){build(:upload)}

    it "fails if the file is bigger than 2byte" do
      id2 = ins.save
      id2 = ins.destroy
      expect{ins.save!}.to raise_error GollumRails::Upload::FileTooBigError
    end
  end


end
