require 'bundler/setup'

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
