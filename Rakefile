#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

desc 'Default: run test.'
task :default => :test

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
