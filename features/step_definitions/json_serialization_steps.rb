Given(/^a model instance defined as:$/) do |code|
  instance = nil
  context_module.module_eval(code)
  context_data[:instance] = instance
end

When(/^the instance's property values are assigned as:$/) do |code|
  instance = context_data[:instance]
  eval code
end

When(/^the model is serialized to JSON as:$/) do |code|
  instance = context_data[:instance]
  json = nil
  eval code
  context_data[:resulting_json] = json
end

Then(/^the resulting JSON is equivalent to:$/) do |expected_json_equivalent|
  expected_json = JSON.parse(expected_json_equivalent)
  actual_json = context_data[:resulting_json]
  expect( actual_json ).to eq( expected_json )
end
