Given(/^an object model defined as:$/) do |code|
  context_module.module_eval(code)
end

Given(/^a model instance constructed as:$/) do |code|
  instance = nil
  context_module.module_eval(code)
  context_data[:instance] = instance
end

