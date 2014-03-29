require "bundler/gem_tasks"
require "rspec/core/rake_task"


desc "Run all specs and features"
task all_tests: %w[spec cucumber cucumber:wip]

task :default => :all_tests


RSpec::Core::RakeTask.new(:spec)


require "cucumber"
require "cucumber/rake/task"

Cucumber::Rake::Task.new

namespace :cucumber do
  Cucumber::Rake::Task.new :wip do |t|
    t.profile = 'wip'
  end
end
