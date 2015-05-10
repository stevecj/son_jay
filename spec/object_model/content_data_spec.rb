require 'spec_helper'

describe SonJay::ObjectModel::ContentData do

  it "provides value access by name symbol or string" do
    subject[ :aaa  ] = 1
    subject[ 'bbb' ] = 2
    expect( subject[ 'aaa' ] ).to eq( 1 )
    expect( subject[ :bbb  ] ).to eq( 2 )
  end

  it "merges with a hash, returning a hash" do
    subject[ :aa  ] = 1
    subject[ :bb  ] = 2

    actual = subject.hash_merge(
      "bb" => 22,
      "cc" => 33
    )

    expect( actual ).to eq(
      'aa' => 1,
      'bb' => 22,
      'cc' => 33
    )
  end

  it "indicates when it is empty" do
    expect( subject ).to be_empty
  end

  it "indicates when it is not empty" do
    subject[:a] = 'a'
    expect( subject ).not_to be_empty
  end

end
