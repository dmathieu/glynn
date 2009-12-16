require 'rubygems'
require 'spec/rake/spectask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "glynn"
    gemspec.summary = "Deploy a jekyll weblog through ftp"
    gemspec.description = "Deploy a jekyll weblog through ftp"
    gemspec.email = "42@dmathieu.com"
    gemspec.homepage = "http://github.com/dmathieu/glynn"
    gemspec.authors = ["Damien MATHIEU"]
    gemspec.version = '0.0.1'
    
    gemspec.add_dependency('jekyll', '>= 0.5.4')
  end
rescue LoadError
  puts "Jeweler not available. Install it with:"
  puts "gem install jeweler"
end

#
# The rspec tasks
#
task :default => :spec
 
desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.spec_opts = ['-cfs']
end

#
# The sdoc generator
#
begin
  require 'sdoc_helpers'
rescue LoadError
  puts "sdoc support not enabled. Please gem install sdoc-helpers."
end
