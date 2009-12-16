require File.dirname(__FILE__) + '/../spec_helper'
 
describe "Relation between glynn and jekyll" do
  before(:all) do
    FakeFS.activate!
    File.open('/_config.yml', 'w') { |f| f.write 'auto: true' }
  end
  after(:all) do
    FakeFS.deactivate!
  end
  
  it 'should create a new website' do
    jekyll = Glynn::Jekyll.new({ 'source' => '/' })
    jekyll.build
  end
  
  it 'should accept the ftp host option' do
    File.open('/_config.yml', 'w') { |f| f.write 'ftp_host: example.com' }
    options = Jekyll.configuration({'source' => '/'})
    options['ftp_host'].should eql('example.com')
  end
end