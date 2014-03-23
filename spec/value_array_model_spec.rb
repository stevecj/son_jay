require 'spec_helper'

describe SonJay::ValueArrayModel do
  subject{ described_class.new( *init_args ) }
  let( :init_args ){ [] }

  it "is empty by default" do
    expect( subject ).to be === []
  end

  describe "instance methods" do
    let( :init_args ){ [internal_array] }
    let( :internal_array ){ double(:internal_array) }

    before do
      internal_array.stub to_ary: internal_array
    end

    it "returns a copy of its internal array from #to_a" do
      internal_array.stub dup: :internal_array_dup
      expect( subject.to_a ).to eq( :internal_array_dup )
    end

    it "returns its internal array data from #as_json" do
      expect( subject.as_json ).to eq( internal_array )
    end

    it "returns a JSON representation of its data from #to_json" do
      internal_array.stub to_json: :the_json_representation
      expect( subject.to_json ).to eq( :the_json_representation )
    end

    #TODO: Duplicates code under test. Better way to cover this?
    methods_delegated_to_int_array =
      Array.instance_methods - Object.instance_methods - [:to_a, :to_ary]
      
    methods_delegated_to_int_array.sort.each do |msg|
      it "delegates ##{msg} to its internal array" do
        expect( internal_array ).to receive( msg )
        subject.public_send msg
      end
    end

  end

end
