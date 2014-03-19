require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require "cucumber"
require "cucumber/rake/task"

Cucumber::Rake::Task.new

namespace :cucumber do
  Cucumber::Rake::Task.new :wip do |t|
    t.profile = 'wip'
  end
end
