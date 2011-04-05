module Glynn
  class File
    
    def self.is_bin?(f)
      %x(file #{f}) !~ /text/
    end
  end
end