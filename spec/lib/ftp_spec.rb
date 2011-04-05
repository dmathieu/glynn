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
    @mock.should_receive(:close)
    Net::FTP.should_receive(:new).with('localhost', nil, nil).and_return(@mock)
    
    
    Glynn::Ftp.new('localhost').send(:connect) do |ftp|
      ftp.should eql(@mock)
    end
  end
  
  it 'should accept a username and password' do
    @mock.should_receive(:close)
    Net::FTP.should_receive(:new).with('localhost', 'username', 'password').and_return(@mock)
    
    Glynn::Ftp.new('localhost', 21, {:username => 'username', :password => 'password'}).send(:connect) do |ftp|
      ftp.should eql(@mock)
    end
  end
  
  it 'should recursively send a directory' do
    # We expect NET/FTP to create every file
    @mock.should_receive(:putbinaryfile).with('/test/README', '/blah/README').and_return(true)
    @mock.should_receive(:putbinaryfile).with('/test/subdir/README', '/blah/subdir/README').and_return(true)
    @mock.should_receive(:mkdir).with('/blah')
    @mock.should_receive(:mkdir).with('/blah/subdir').twice
    
    FakeFS do
      # We create the fake files and directories
      Dir.mkdir('/test') unless File.exists?('/test')
      Dir.mkdir('/test/subdir') unless File.exists?('/test')
      File.open('/test/README', 'w') { |f| f.write 'N/A' }
      File.open('/test/subdir/README', 'w') { |f| f.write 'N/A' }
      
      # And send them
      Glynn::Ftp.new('localhost').send(:send_dir, @mock, '/test', '/blah')
    end
  end
  
  it 'should connect itself to the server and send the local file to distant directory' do
    @mock.should_receive(:close)
    
    FakeFS do
      interface = Glynn::Ftp.new('localhost')
      Net::FTP.should_receive(:new).with('localhost', nil, nil).and_return(@mock)
      interface.should_receive(:send_dir).with(@mock, '/test', '/blah')
      
      interface.sync '/test', '/blah'
    end
  end
end