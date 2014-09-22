require 'fakefs/dir'

module FakeFS
  class File

    class << self
      def fnmatch?(pattern, path)
        path.match(pattern)
      end
    end
  end
end
