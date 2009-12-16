require 'net/ftp'

module Glynn
  class Ftp
    attr_reader :host, :port, :username, :password
    
    def initialize(host, port = 21, options = Hash.new)
      @host, @port = host, port
    end
    
    def sync(local, distant)
      connect do |ftp|
        send_dir(ftp, local, distant)
      end
    end
    
    private
    def connect
      ftp = Net::FTP.new(host)
      ftp.login
      yield ftp
      ftp.close
    end
    
    def send_dir(ftp, local, distant)
      Dir.foreach(local) do |file_name|
        # If the file/directory is hidden (first character is a dot), we ignore it
        next if file_name =~ /^\./
        
        if File.stat(local + "/" + file_name).directory?
          # It is a directory, we recursively send it
          send_dir(ftp, local + "/" + file_name, distant + "/" + file_name)
        else
           # It's a file, we just send it
           ftp.puttextfile(local + "/" + file_name, distant + "/" + file_name)
        end
      end
      
    end
  end
end
