require 'rubygems'
require 'mocha/api'
require 'fakefs/safe'

def load_all(*patterns)
  patterns.each { |pattern| Dir[pattern].sort.each { |path| load File.expand_path(path) } }
end

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'glynn'
load_all 'spec/support/**/*.rb'
