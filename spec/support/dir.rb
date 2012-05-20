require 'fakefs/dir'

module FakeFS
  class Dir

    class << self
      alias :old_glob :glob
      def glob(pattern, flags=nil, &block)
        old_glob(pattern, &block)
      end
    end
  end
end
