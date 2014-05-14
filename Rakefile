require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run all specs/features with and w/o ActiveSupport loaded"
task :all_tests do
  system 'rake all_tests_without_active_support'
  next unless $?.exitstatus == 0
  system 'rake all_tests_with_active_support'
end

task :default => :all_tests

desc "Run all specs and features w/o ActiveSupport loaded"
task all_tests_without_active_support: %w[all_test_types]

desc "Run all specs and features with ActiveSupport loaded"
task all_tests_with_active_support: %w[load_active_support all_test_types]

task all_test_types: %w[spec cucumber cucumber:wip]

RSpec::Core::RakeTask.new(:spec)


require "cucumber"
require "cucumber/rake/task"

Cucumber::Rake::Task.new

namespace :cucumber do
  Cucumber::Rake::Task.new :wip do |t|
    t.profile = 'wip'
  end
end

task :load_active_support do
  ENV['LOAD_ACTIVE_SUPPORT'] = '1'
end
