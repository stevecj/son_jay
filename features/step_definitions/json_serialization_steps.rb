Given(/^a model instance defined as:$/) do |code|
  instance = nil
  context_module.module_eval code
  context_data[:instance] = instance
end

When(/^the instance's property values are assigned as:$/) do |code|
  instance = context_data[:instance]
  context_module.module_eval code
end

When(/^the model is serialized as:$/) do |code|
  pending # express the regexp above with the code you wish you had
end

Then(/^the resulting JSON is equivalent to:$/) do |code|
  pending # express the regexp above with the code you wish you had
end
