When(/^data is disseminated to the domain object as:$/) do |code|
  instance = context_data[:instance]
  object   = context_data[:object]
  context_module.module_eval code
end

Then(/^the domain object attributes are as follows:$/) do |table|
  object_attributes_match_table! context_data[:object], table
end
