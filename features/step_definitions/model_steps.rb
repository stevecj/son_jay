Given(/^an object model defined as:$/) do |code|
  context_module.module_eval(code)
end

Given(/^a model instance constructed as:$/) do |code|
  instance = nil
  context_module.module_eval(code)
  context_data[:instance] = instance
end

Given(/^an object array model instance constructed as:$/) do |code|
  pending # express the regexp above with the code you wish you had
end
