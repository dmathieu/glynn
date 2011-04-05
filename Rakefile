require 'bundler/setup'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "glynn"
    gemspec.summary = "Deploy a jekyll weblog through ftp"
    gemspec.description = "Deploy a jekyll weblog through ftp"
    gemspec.email = "42@dmathieu.com"
    gemspec.homepage = "http://github.com/dmathieu/glynn"
    gemspec.authors = ["Damien MATHIEU"]
    
    gemspec.add_dependency('jekyll', '>= 0.5.4')
  end
rescue LoadError
  puts "Jeweler not available. Install it with:"
  puts "gem install jeweler"
end

#
# The rspec tasks
#
require 'rspec/core'
require 'rspec/core/rake_task'
task :default => :spec
RSpec::Core::RakeTask.new(:spec)

#
# The sdoc generator
#
begin
  require 'sdoc_helpers'
rescue LoadError
  puts "sdoc support not enabled. Please gem install sdoc-helpers."
end
