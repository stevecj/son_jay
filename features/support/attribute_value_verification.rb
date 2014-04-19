def object_attributes_match_table!(obj, table)
  row_pairs = table.raw.each_slice(2)
  attribute_exprs = row_pairs.map( &:first ).reduce( :+ )
  expected_exprs  = row_pairs.map( &:last  ).reduce( :+ )

  actuals   = attribute_exprs .map{ |expr| eval( "obj.#{expr}" ) }
  expecteds = expected_exprs  .map{ |expr| eval(  expr              ) }

  actual_hash   = Hash[ attribute_exprs.zip( actuals   ) ]
  expected_hash = Hash[ attribute_exprs.zip( expecteds ) ]
  expect( actual_hash ).to eq( expected_hash )
end
