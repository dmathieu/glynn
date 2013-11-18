require 'iconv' unless String.method_defined?(:encode)

module Glynn
  class File

    class << self
      def is_bin?(f)
        force_utf8(%x(file #{f})) !~ /text/
      end

      private

      def force_utf8(contents)
        # http://stackoverflow.com/a/8873922
        if String.method_defined?(:encode)
          contents.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
          contents.encode!('UTF-8', 'UTF-16')
          contents
        else
          ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
          ic.iconv(file_contents)
        end
      end
    end
  end
end
