# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'glynn/version'

Gem::Specification.new do |s|
  s.name         = "glynn"
  s.version      = Glynn::VERSION
  s.authors      = ["Damien MATHIEU"]
  s.email        = "42@dmathieu.com"
  s.description  = "Deploy a jekyll weblog through ftp"
  s.summary      = "Deploy a jekyll weblog through ftp"
  s.homepage     = "https://github.com/dmathieu/glynn"
  s.license      = "MIT"

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'

  s.executables  = ['glynn']

  s.add_development_dependency "bundler"
  s.add_development_dependency "minitest"

  s.add_dependency('jekyll', [">= 0"])
  s.add_dependency('double-bag-ftps', ["~> 0.1.2"])
end
