with_active_support = !!ENV['LOAD_ACTIVE_SUPPORT']

if with_active_support
  gem 'activesupport'
  require 'active_support/all'
  puts 'ActiveSupport loaded'
end

gem 'simplecov'
require 'simplecov'
cmd_active_supp_qual = with_active_support ? 'with' : 'without'
SimpleCov.command_name "rspec:#{cmd_active_supp_qual}_active_support"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'son_jay'
