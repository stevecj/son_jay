if ENV['LOAD_ACTIVE_SUPPORT']
  gem 'activesupport'
  require 'active_support/all'
  puts 'ActiveSupport loaded'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'son_jay'
