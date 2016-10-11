module FakeFS
  module FileUtils

    class << self
      def copy_entry(src, dest, preserve = false, dereference_root = false, remove_destination = false)
        cp_r(src, dest)
      end
    end
  end
end
