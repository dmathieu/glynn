require File.dirname(__FILE__) + '/../spec_helper'

describe "FTP Interface" do
  before(:each) do
    # We mock the FTP server
    @mock = mock('Ftp server').as_null_object

    # And the puttextfile method
    class Net::FTP
      def puttextfile; true; end
    end
  end

  it 'should connect to ftp server' do
    Net::FTP.should_receive(:open).with('localhost').and_return(@mock)

    Glynn::Ftp.new('localhost').send(:connect) do |ftp|
      ftp.should eql(@mock)
    end
  end

  it 'should login to ftp server' do
    Net::FTP.should_receive(:open).with('localhost').and_return(@mock)

    Glynn::Ftp.new('localhost').send(:connect) do |ftp|
      @mock.should_receive(:login).with(nil, nil)
    end
  end

  it 'should use the given port' do
    Net::FTP.should_receive(:open).with('localhost').and_return(@mock)

    Glynn::Ftp.new('localhost', 1234).send(:connect) do |ftp|
      @mock.should_receive(:connect).with('localhost', 1234)
      ftp.should eql(@mock)
    end
  end

  it 'should make an active connection' do
    Net::FTP.should_receive(:open).with('localhost').and_return(@mock)

    Glynn::Ftp.new('localhost', 21, {passive: true}).send(:connect) do |ftp|
      @mock.should_receive(:passive).with(false)
      ftp.should eql(@mock)
    end
  end

  it 'should make a passive connection' do
    Net::FTP.should_receive(:open).with('localhost').and_return(@mock)

    Glynn::Ftp.new('localhost', 21, {passive: true}).send(:connect) do |ftp|
      @mock.should_receive(:passive).with(true)
      ftp.should eql(@mock)
    end
  end

  it 'should make a secure connection' do
    DoubleBagFTPS.should_receive(:open).with('localhost').and_return(@mock)

    Glynn::Ftp.new('localhost', 21, {secure: true}).send(:connect) do |ftp|
      ftp.should eql(@mock)
    end
  end

  it 'should accept a username and password' do
    Net::FTP.should_receive(:open).with('localhost').and_return(@mock)

    Glynn::Ftp.new('localhost', 21, {:username => 'username', :password => 'password'}).send(:connect) do |ftp|
      @mock.should_receive(:login).with('username', 'password')
      ftp.should eql(@mock)
    end
  end

  it 'should recursively send a directory' do
    # We expect NET/FTP to create every file
    @mock.should_receive(:putbinaryfile).with('/test/README', '/blah/README').and_return(true)
    @mock.should_receive(:putbinaryfile).with('/test/.gitignore', '/blah/.gitignore').and_return(true)
    @mock.should_receive(:putbinaryfile).with('/test/subdir/README', '/blah/subdir/README').and_return(true)
    @mock.should_receive(:mkdir).with('/blah')
    @mock.should_receive(:mkdir).with('/blah/subdir').twice

    FakeFS do
      # We create the fake files and directories
      FileUtils.mkdir_p('/test/subdir') if !File.directory?('/test/subdir')
      File.open('/test/README', 'w') { |f| f.write 'N/A' }
      File.open('/test/.gitignore', 'w') { |f| f.write 'N/A' }
      File.open('/test/subdir/README', 'w') { |f| f.write 'N/A' }

      # And send them
      Glynn::Ftp.new('localhost').send(:send_dir, @mock, '/test', '/blah')
    end
  end

  it 'should connect itself to the server and send the local file to distant directory' do
    FakeFS do
      Net::FTP.should_receive(:open).with('localhost').and_return(@mock)
      interface = Glynn::Ftp.new('localhost') do |ftp|
        @mock.should_receive(:connect).with('localhost', 21)
        @mock.should_receive(:login).with(nil, nil)
        interface.should_receive(:send_dir).with(@mock, '/test', '/blah')
      end

      interface.sync '/test', '/blah'
    end
  end
end
