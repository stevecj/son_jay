Given(/^a JSON string defined as:$/) do |code|
  json = nil
  eval code
  context_data[:json] = json
end

When(/^the JSON is parsed to an object model instance as:$/) do |code|
  instance = nil
  json = context_data[:json]
  context_module.module_eval(code)
  context_data[:instance] = instance
end

Then(/^the instance property values are:$/) do |table|
  expected_prop_vals = table.hashes.first
  instance = context_data[:instance]
  expected_prop_vals.each do |property, expected_val_expr|
    expected_val = eval(expected_val_expr)
    actual_val = eval("instance.#{property}")
    expect( actual_val ).to eq( expected_val )
  end
end

When(/^the JSON is parsed to a value array model instance as:$/) do |code|
  pending # express the regexp above with the code you wish you had
end

Then(/^the instance has an entries sequencce of:$/) do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
