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

  describe '#freeze' do
    it "causes the instance to behave as frozen" do
      subject.freeze
      expect{ subject['a'] = 1 }.to raise_exception( RuntimeError )
    end
  end

  describe '#dup' do
    it "makes a shallow copy" do
      subject[ 'aa' ] = 'A'
      subject[ 'bb' ] = 'B'
      actual_dup = subject.dup
      expect( actual_dup.keys ).to match_array( ['aa', 'bb'] )
      expect( actual_dup['aa'] ).to equal( subject['aa'] )
      actual_dup['bb'] = 'BBB'
      expect( subject['bb'] ).to eq( 'B' )
    end

    it "returns a thawed copy of a frozen instance" do
      subject.freeze
      actual_dup = subject.dup
      expect( actual_dup ).not_to be_frozen
      actual_dup['aa'] = 1
      expect( actual_dup['aa'] ).to eq( 1 )
    end
  end

  describe '#clone' do
    it "makes a shallow copy" do
      subject[ 'aa' ] = 'A'
      subject[ 'bb' ] = 'B'
      actual_clone = subject.clone
      expect( actual_clone.keys ).to match_array( ['aa', 'bb'] )
      expect( actual_clone['aa'] ).to equal( subject['aa'] )
      actual_clone['bb'] = 'BBB'
      expect( subject['bb'] ).to eq( 'B' )
    end

    it "returns a frozen copy of a frozen instance" do
      subject.freeze
      expect( subject.clone ).to be_frozen
    end
  end

end
