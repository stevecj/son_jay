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
  attribute_specs = table.hashes.first
  instance = context_data[:instance]
  attribute_specs.each do |attr, expected_val_expr|
    actual_val = eval( "instance.#{attr}" )
    expected_val = eval( expected_val_expr )
    expect( actual_val ).to eq( expected_val )
  end
end
