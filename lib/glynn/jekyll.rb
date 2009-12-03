require 'jekyll'

module Glynn
  class Jekyll
    #
    # Builds the website in the ./_site directory.
    def self.build
      
      site = Jekyll::Site.new(Jekyll.configuration)
      site.process
    end
  end
end
