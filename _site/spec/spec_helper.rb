require 'rubygems'
require 'spec'
require 'mocha'
require 'spec/autorun'
require 'spec/interop/test'
require 'fakefs/safe'


$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'glynn'

Spec::Runner.configure do |config|
  
  
end