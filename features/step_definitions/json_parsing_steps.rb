Given(/^JSON data defined as:$/) do |code|
  json = nil
  context_module.module_eval code
  context_data[:json] = json
end

When(/^the JSON is parsed to a model instance as:$/) do |code|
  json = context_data[:json]
  instance = nil
  context_module.module_eval code
  context_data[:instance] = instance
end

Then(/^the instance attributes are as follows:$/) do |table|
  #TODO Factor out duplication with "the domain object attributes are as follows:"
  row_pairs = table.raw.each_slice(2)
  attribute_exprs = row_pairs.map( &:first ).reduce( :+ )
  expected_exprs  = row_pairs.map( &:last  ).reduce( :+ )

  instance = context_data[:instance]
  actuals   = attribute_exprs .map{ |expr| eval( "instance.#{expr}" ) }
  expecteds = expected_exprs  .map{ |expr| eval(  expr              ) }

  actual_hash   = Hash[ attribute_exprs.zip( actuals   ) ]
  expected_hash = Hash[ attribute_exprs.zip( expecteds ) ]
  expect( actual_hash ).to eq( expected_hash )
end
