require File.dirname(__FILE__) + '/../spec_helper'
 
describe "Relation between glynn and jekyll" do
  before(:all) do
    FakeFS.activate!
  end
  after(:all) do
    FakeFS.deactivate!
  end
  
  it 'should create a new website' do
    jekyll = Glynn::Jekyll.new({ 'source' => '/' })
    jekyll.build
  end
end