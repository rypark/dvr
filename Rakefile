require "bundler/gem_tasks"

task :default => :test

desc 'Run the test suite'
task :test do |t|
  Dir[__dir__ + '/spec/**/*.spec.rb'].each(&method(:require))
end
