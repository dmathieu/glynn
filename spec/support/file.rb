require 'fakefs/dir'

module FakeFS
  class File

    class << self
      def fnmatch?(pattern, path)
        path.match(pattern)
      end

      def binwrite(name, string, offset=0)
        File.open(name, 'w') {|f| f.write string }
      end
    end
  end
end
