When(/^the instance's property values are assigned as:$/) do |code|
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

When(/^instance elements are added as:$/) do |code|
  instance = context_data.fetch( :instance )
  eval code
end

When(/^the instance's element values are assigned as:$/) do |code|
  pending # express the regexp above with the code you wish you had
end
