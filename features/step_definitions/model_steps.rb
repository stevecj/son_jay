Given(/^an object model defined as:$/) do |code|
  context_module.module_eval(code)
end
