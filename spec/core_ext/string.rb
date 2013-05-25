# Setup testing
require 'spec_helper'
describe String do
  it "should matches the specified versions" do
    "bla".should respond_to(:getord)
  end

end
