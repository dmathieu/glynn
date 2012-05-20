require File.dirname(__FILE__) + '/../spec_helper'

describe "File module" do
  before(:all)  do
    FakeFS.activate!
    FileUtils.mkdir("/test")
  end
  after(:all) do
    FakeFS.deactivate!
  end

  it "should return file is text" do
    File.open('/test/README', 'w') { |f| f.write 'N/A' }
    Glynn::File.is_bin?('/test/README').should eql(true)
  end

  it "should return file is binary" do
    File.open('/test/README', 'w') { |f| f.write ['0', '1', '2', '3'].pack('A3A3A3') }
    Glynn::File.is_bin?('/test/README').should eql(true)
  end
end
