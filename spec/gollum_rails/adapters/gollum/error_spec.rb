require 'spec_helper'

describe GollumRails::Adapters::ActiveModel::Error do
  it "should test the error throwing" do
    expect{raise GollumRails::Adapters::ActiveModel::Error.new 'test', 'no'}.to raise_error GollumRails::Adapters::ActiveModel::Error
  end
end
