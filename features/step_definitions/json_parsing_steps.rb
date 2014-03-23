Given(/^a JSON string defined as:$/) do |code|
  json = nil
  eval code
  context_data[:json] = json
end

When(/^the JSON is parsed to a.* instance as:$/) do |code|
  instance = nil
  json = context_data.fetch( :json )
  context_module.module_eval( code )
  context_data[:instance] = instance
end

Then(/^the instance property values are:$/) do |table|
  expected_prop_vals = table.hashes.first
  instance = context_data.fetch( :instance )
  expected_prop_vals.each do |property, expected_val_expr|
    expected_val = eval( expected_val_expr )
    actual_val = eval("instance.#{property}")
    expect( actual_val ).to eq( expected_val )
  end
end

Then(/^the instance has an entries sequencce of:$/) do |table|
  expected_expressions = table.raw.first
  expected_entries = expected_expressions.map{ |exp| eval(exp) }
  instance = context_data.fetch( :instance )
  actual_entries = instance.entries
  expect( actual_entries ).to eq( expected_entries )
end
