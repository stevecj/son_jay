Given(/^a.* instance constructed as:$/) do |code|
  instance = nil
  context_module.module_eval(code)
  context_data[:instance] = instance
end

When(/^instance .* are .* as:$/) do |code|
  instance = context_data.fetch( :instance )
  eval code
end

When(/^the model is serialized to JSON as:$/) do |code|
  instance = context_data.fetch( :instance )
  json = nil
  eval code
  context_data[:resulting_json] = json
end

Then(/^the resulting JSON is equivalent to:$/) do |expected_json_equivalent|
  expected_data = JSON.parse( expected_json_equivalent )
  resulting_json = context_data.fetch( :resulting_json )
  actual_data = JSON.parse( resulting_json )
  expect( actual_data ).to eq( expected_data )
end
