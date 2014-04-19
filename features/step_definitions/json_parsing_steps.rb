Given(/^JSON data defined as:$/) do |code|
  json = nil
  context_module.module_eval code
  context_data[:json] = json
end

When(/^the JSON is parsed to a model instance as:$/) do |code|
  json = context_data[:json]
  instance = nil
  context_module.module_eval code
  context_data[:instance] = instance
end

Then(/^the instance attributes are as follows:$/) do |table|
  object_attributes_match_table! context_data[:instance], table
end
