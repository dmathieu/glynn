require File.dirname(__FILE__) + '/../spec_helper'
 
describe "FTP Interface" do
  before(:each) do
    # We mock the FTP server
    @mock = mock('Ftp server', :null_object => true)
    
    # And the puttextfile method
    class Net::FTP
      def puttextfile; true; end
    end
  end
  
  it 'should login to ftp server' do
    Net::FTP.should_receive(:new).with('localhost').and_return(@mock)
    Glynn::Ftp.new('localhost').send(:connect) do |ftp|
      ftp.should eql(@mock)
    end
  end
  
  it 'should recursively send a directory' do
    # We expect NET/FTP to create every file
    @mock.should_receive(:puttextfile).with('/test/README', '/blah/README').and_return(true)
    @mock.should_receive(:puttextfile).with('/test/subdir/README', '/blah/subdir/README').and_return(true)
    FakeFS do
      # We create the fake files and directories
      Dir.mkdir('/test')
      Dir.mkdir('/test/subdir')
      File.open('/test/README', 'w') { |f| f.write 'N/A' }
      File.open('/test/subdir/README', 'w') { |f| f.write 'N/A' }
      
      # And send them
      Glynn::Ftp.new('localhost').send(:send_dir, @mock, '/test', '/blah')
    end
  end
end