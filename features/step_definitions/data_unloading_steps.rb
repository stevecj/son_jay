When(/^data is disseminated to the domain object as:$/) do |code|
  instance = context_data[:instance]
  object   = context_data[:object]
  context_module.module_eval code
end

Then(/^the domain object attributes are as follows:$/) do |table|
  #TODO Factor out duplication with "the instance attributes are as follows:"
  row_pairs = table.raw.each_slice(2)
  attribute_exprs = row_pairs.map( &:first ).reduce( :+ )
  expected_exprs  = row_pairs.map( &:last  ).reduce( :+ )

  object = context_data[:object]
  actuals   = attribute_exprs .map{ |expr| eval( "object.#{expr}" ) }
  expecteds = expected_exprs  .map{ |expr| eval(  expr              ) }

  actual_hash   = Hash[ attribute_exprs.zip( actuals   ) ]
  expected_hash = Hash[ attribute_exprs.zip( expecteds ) ]
  expect( actual_hash ).to eq( expected_hash )
end
