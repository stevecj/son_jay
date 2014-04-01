Given(/^a model instance defined as:$/) do |code|
  instance = nil
  context_module.module_eval code
  context_data[:instance] = instance
end

When(/^the instance's property values are assigned as:$/) do |code|
  instance = context_data[:instance]
  context_module.module_eval code
end

When(/^the model is serialized to JSON as:$/) do |code|
  instance = context_data[:instance]
  json = nil
  context_module.module_eval code
  context_data[:json] = json
end

Then(/^the resulting JSON is equivalent to:$/) do |expected_json_equivalent|
  expected_data = JSON.parse( expected_json_equivalent )
  actual_data = JSON.parse( context_data[:json] )
  expect( actual_data ).to eq( expected_data )
end
