require 'net/ftp'
require 'double_bag_ftps'

module Glynn
  class Ftp
    attr_reader :host, :port, :username, :password, :passive, :secure

    def initialize(host, port = 21, options = Hash.new)
      options = {:username => nil, :password => nil}.merge(options)
      @host, @port = host, port
      @username, @password = options[:username], options[:password]
      @passive, @secure = options[:passive], options[:secure]
    end

    def sync(local, distant)
      connect do |ftp|
        send_dir(ftp, local, distant)
      end
    end

    private
    def connect
      ftp_klass.open(host) do |ftp|
        ftp.passive = @passive
        ftp.connect(host, port)
        ftp.login(username, password)
        yield ftp
      end
    end

    def ftp_klass
      if secure
        DoubleBagFTPS
      else
        Net::FTP
      end
    end

    def send_dir(ftp, local, distant)
      begin
        ftp.mkdir(distant)
      rescue Net::FTPPermError
        # We don't do anything. The directory already exists.
        # TODO : this is also risen if we don't have write access. Then, we need to raise.
      end
      Dir.foreach(local) do |file_name|
        # If the file/directory is hidden (first character is a dot), we ignore it
        next if file_name =~ /^(\.|\.\.)$/

        puts " -> " + file_name
        if ::File.stat(local + "/" + file_name).directory?
          # It is a directory, we recursively send it
          begin
            ftp.mkdir(distant + "/" + file_name)
          rescue Net::FTPPermError
            # We don't do anything. The directory already exists.
            # TODO : this is also risen if we don't have write access. Then, we need to raise.
          end
          send_dir(ftp, local + "/" + file_name, distant + "/" + file_name)
        else
           # It's a file, we just send it
           if Glynn::File.is_bin?(local + "/" + file_name)
             ftp.putbinaryfile(local + "/" + file_name, distant + "/" + file_name)
           else
             ftp.puttextfile(local + "/" + file_name, distant + "/" + file_name)
           end
        end
      end
    end

    private
    def host_with_port
      "#{host}:#{port}"
    end
  end
end
