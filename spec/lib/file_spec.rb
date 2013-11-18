require File.dirname(__FILE__) + '/../spec_helper'

describe "File module" do
  describe "with FakeFS" do
    before(:all)  do
      FakeFS.activate!
      FileUtils.mkdir("/test") if !File.directory?('/test')
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

  describe "shell integration" do
    require 'tempfile'

    let(:garbled_jpg) do
      f = Tempfile.new('garbled.jpg')
      f.write "\xff\xd8\xff\xe0\x00\x10\x4a\x46\x49\x46\x00\x01\x01\x01\x00\x48\x00\x48\x00\x00\xff\xfe\x00\x03\x2a\xff\xdb"
      f.close
      f
    end

    it "should handle binary content in file info" do
      puts "Press any key to continue"
      readline
      Glynn::File.is_bin?(garbled_jpg.path).should be_true
    end

  end
end

