module Glynn
  class File

    def self.is_bin?(f)
      file_test = %x(file #{f})

      # http://stackoverflow.com/a/8873922
      file_test = file_test.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '').encode('UTF-8', 'UTF-16')

      file_test !~ /text/
    end
  end
end
