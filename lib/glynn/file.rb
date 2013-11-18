module Glynn
  class File

    class << self
      def is_bin?(f)
        force_utf8(%x(file #{f})) !~ /text/
      end

      private

      def force_utf8(contents)
        # http://stackoverflow.com/a/8873922
        contents.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '').encode('UTF-8', 'UTF-16')
      end
    end
  end
end
