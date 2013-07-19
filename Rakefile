require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :test

desc 'Run the test suite'
task :test do |t|
  Rake::Task['test:minitest'].invoke
  Rake::Task['spec'].invoke
end

namespace :test do

  desc 'Run Minitest tests only'
  task :minitest do |t|
    Dir[__dir__ + '/spec/**/*.spec.rb'].each(&method(:require))
  end

  desc 'Run RSpec tests only'
  task :rspec do |t|
    Rake::Task['spec'].invoke
  end

end

RSpec::Core::RakeTask.new(:spec)