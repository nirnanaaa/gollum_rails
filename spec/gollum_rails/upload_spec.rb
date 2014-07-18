require 'spec_helper'

describe GollumRails::Upload do
  describe "#initialize(file, destination='uploads')" do
    let(:ins){build(:upload)}
    it "should set accessor file to file" do
      expect(ins.file).to be_instance_of Rack::Test::UploadedFile
    end
    it "should set accessor destination to /uploads" do
      expect(ins.destination) == "uploads"
    end
    it "should set accessor commit to factory hash" do
      expect(ins.commit).to be_kind_of Hash
    end
    it "has not an empty commit" do
      expect(ins.commit).not_to be_empty
    end
  end

  describe "#save" do
    let(:ins){build(:upload, destination: "blafasel")}

    it "performs debugging" do
      ins.save
      file = GollumRails::Upload.wiki.file("blafasel/#{ins.file.original_filename}")
      expect(file).not_to be_nil
      ins.destroy
    end
    it "is persisted after save" do
      ins.save
      expect(ins.persisted?) == true
      ins.destroy
    end
    it "is not persisted after destroy" do
      ins.save
      ins.destroy
      expect(ins.persisted?) == false
    end
    it "is not persisted without saving" do
      expect(ins.persisted?) == false
    end
  end

  describe "#destroy" do
    let(:ins){build(:upload, destination: "destroy")}
    it "is empty after destruction" do
      ins.destroy
      file = GollumRails::Upload.find("destroy/#{ins.file.original_filename}")
      expect(file.gollum_file).to be_nil
    end
    it "returns a commit id on destroy" do
      ins.save
      expect(ins.destroy).to be_instance_of(String)
    end
  end

  describe "::create" do

  end

  describe "::find(path)" do

  end
end
