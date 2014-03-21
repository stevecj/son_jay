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
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end
