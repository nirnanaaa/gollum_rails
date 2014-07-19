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
  it "blacklists formats" do
    expect(SampleUploadBlacklistPng.blacklist).to include :png
  end
  it "whitelists formats" do
    expect(SampleUploadWhitelistPng.whitelist).to include :png
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

  describe "allowed formats to upload" do
    let(:ins2){build(:upload)}
    let(:ins){build(:blacklist_upload)}
    let(:not_blacklisted){build(:not_blacklist_upload)}
    after(:each) do
      ins2.save
      ins2.destroy
    end
    it "does not allow to upload blacklisted formats" do
      begin
        expect{ins.save!}.to raise_error GollumRails::Upload::BlacklistedFiletypeError
      ensure
        ins.destroy
      end
    end
    it "does allow to upload non-blacklisted formats" do
      begin
        expect{not_blacklisted.save!}.not_to raise_error
      ensure
        not_blacklisted.destroy
      end
    end
  end
  describe "whitelist" do
    let(:ins){build(:whitelist_upload)}
    let(:whitelisted){build(:not_whitelist_upload)}
     it "does not allow to upload non-whitelisted formats" do
      begin
        expect{ins.save!}.to raise_error GollumRails::Upload::BlacklistedFiletypeError
      ensure
        ins.destroy
      end
    end
    it "does allow to upload whitelisted formats" do
      begin
        expect{whitelisted.save!}.not_to raise_error
      ensure
        whitelisted.destroy
      end
    end
  end

end
