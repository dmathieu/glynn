require File.dirname(__FILE__) + '/../spec_helper'
 
describe "Relation between glynn and jekyll" do
  
  it 'should create a new website' do
    jekyll = Glynn::Jekyll.new
    jekyll.build
  end
end