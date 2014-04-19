Given(/^a.* object model defined as:$/) do |code|
  context_module.module_eval code
end

Given(/^a domain object(?: is)? created.* as:$/) do |code|
  object = nil
  context_module.module_eval code
  context_data[:object] = object
end
