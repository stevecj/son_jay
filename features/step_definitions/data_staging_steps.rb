When(/^a new SonJay model instance is built from domain object data as:$/) do |code|
  object = context_data[:object]
  instance = nil
  context_module.module_eval code
  context_data[:instance] = instance
end
