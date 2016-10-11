require File.dirname(__FILE__) + '/../spec_helper'

class FakeFtpServer
  attr_accessor :passive

  def self.open(host)
    yield(self.new)
  end

  def connect(host, port); end
  def login(username, password); end

  def mkdir(folder); end
  def putbinaryfile(lfile, dfile); end
  def delete(file); end
  def nlst(match) []; end
end

describe "FTP Interface" do
  before(:each) do
    # We mock the FTP server
    @ftp_klass = Class.new do
      def self.ftp_server
        @ftp_server ||= FakeFtpServer.new
      end

      def self.open(host)
        yield(ftp_server)
      end
    end

    # And the puttextfile method
    class Net::FTP
      def puttextfile; true; end
    end
  end

  it 'should connect to ftp server' do
    glynn = Glynn::Ftp.new('localhost', 21, {ftp_klass: @ftp_klass})

    expect(@ftp_klass.ftp_server).to receive(:login).with(nil, nil)
    expect(@ftp_klass.ftp_server).to receive(:connect).with('localhost', 21)
    expect(@ftp_klass.ftp_server).to receive(:passive=).with(false)
    glynn.send(:connect) do |ftp|
      expect(ftp).to eql(@ftp_klass.ftp_server)
    end
  end

  it 'should use the given port' do
    glynn = Glynn::Ftp.new('localhost', 1234, {ftp_klass: @ftp_klass})
    expect(@ftp_klass.ftp_server).to receive(:connect).with('localhost', 1234)
    glynn.send(:connect) do |ftp|; end
  end

  it 'should make a passive connection' do
    glynn = Glynn::Ftp.new('localhost', 21, {passive: true, ftp_klass: @ftp_klass})
    expect(@ftp_klass.ftp_server).to receive(:passive=).with(true)
    glynn.send(:connect) do |ftp|; end
  end


  it 'should make a non-secure connection' do
    expect(Glynn::Ftp.new('localhost').send(:ftp_klass)).to  eql(Net::FTP)
  end

  it 'should make a secure connection' do
    expect(Glynn::Ftp.new('localhost', 21, {secure: true}).send(:ftp_klass)).to eql(DoubleBagFTPS)
  end

  it 'should accept a username and password' do
    glynn = Glynn::Ftp.new('localhost', 1234, {username: 'username', password: 'password', ftp_klass: @ftp_klass})

    expect(@ftp_klass.ftp_server).to receive(:login).with('username', 'password')
    glynn.send(:connect) {|ftp| }
  end

  it 'should recursively send a directory' do
    mock = @ftp_klass.ftp_server
    # We expect NET/FTP to create every file
    expect(mock).to receive(:putbinaryfile).with('/test/README', '/blah/README').and_return(true)
    expect(mock).to receive(:putbinaryfile).with('/test/.gitignore', '/blah/.gitignore').and_return(true)
    expect(mock).to receive(:putbinaryfile).with('/test/subdir/README', '/blah/subdir/README').and_return(true)
    expect(mock).to receive(:mkdir).with('/blah')
    expect(mock).to receive(:mkdir).with('/blah/subdir').twice

    FakeFS do
      # We create the fake files and directories
      FileUtils.mkdir_p('/test/subdir') if !File.directory?('/test/subdir')
      File.open('/test/README', 'w') { |f| f.write 'N/A' }
      File.open('/test/.gitignore', 'w') { |f| f.write 'N/A' }
      File.open('/test/subdir/README', 'w') { |f| f.write 'N/A' }

      # And send them
      Glynn::Ftp.new('localhost').send(:send_dir, mock, '/test', '/blah')
    end
  end

  it 'should connect itself to the server and send the local file to distant directory' do
    FakeFS do
      # We create the fake files and directories
      FileUtils.mkdir_p('/test/subdir') if !File.directory?('/test/subdir')
      File.open('/test/README', 'w') { |f| f.write 'N/A' }
      File.open('/test/.gitignore', 'w') { |f| f.write 'N/A' }
      File.open('/test/subdir/README', 'w') { |f| f.write 'N/A' }

      interface = Glynn::Ftp.new('localhost', 21, {ftp_klass: @ftp_klass})

      expect(@ftp_klass.ftp_server).to receive(:connect).with('localhost', 21)
      expect(@ftp_klass.ftp_server).to receive(:login).with(nil, nil)
      expect(interface).to receive(:send_dir).with(@ftp_klass.ftp_server, '/test', '/blah')

      interface.sync '/test', '/blah'
    end
  end

  it 'should remove files which do not exist locally anymore' do
    FakeFS do
      # We create the fake files and directories
      FileUtils.mkdir_p('/test/subdir') if !File.directory?('/test/subdir')
      File.open('/test/README', 'w') { |f| f.write 'N/A' }
      File.open('/test/.gitignore', 'w') { |f| f.write 'N/A' }
      File.open('/test/subdir/README', 'w') { |f| f.write 'N/A' }

      interface = Glynn::Ftp.new('localhost', 21, {ftp_klass: @ftp_klass})

      expect(@ftp_klass.ftp_server).to receive(:nlst).and_return(["/test/foobar", "/test/README"])
      expect(@ftp_klass.ftp_server).to receive(:delete).with("/test/foobar")
      expect(@ftp_klass.ftp_server).not_to receive(:delete).with("/test/README")
      interface.sync '/test', '/blah'
    end
  end
end
