require 'jekyll'

module Glynn
  class Jekyll
    attr_reader :site
    
    def initialize
      @site = ::Jekyll::Site.new(::Jekyll.configuration({}))
    end
    
    #
    # Builds the website in the ./_site directory.
    #
    def build
      site.process
    end
  end
end
