require 'spec_helper'

describe SonJay::ValueArrayModel do
  subject{ described_class.new( init_options ) }
  let( :init_options ){ {} }
  let( :internal_array ){
    ia = double(:internal_array)
    ia.stub to_ary: ia
    ia
  }

  it "is empty by default" do
    expect( subject ).to eq( [] )
  end

  it "returns a copy of its internal array from #to_a" do
    internal_array = [1, 2, 3]
    init_options[:internal_array] = internal_array
    expect( subject.to_a ).to eq( internal_array )
    expect( subject.to_a ).not_to be( internal_array )
  end

  it "returns its internal array data from #as_json" do
    internal_array = [1, 2, 3]
    init_options[:internal_array] = internal_array
    expect( subject.as_json ).to eq( internal_array )
  end

  it "returns a JSON representation of its data from #to_json" do
    init_options[:internal_array] = internal_array
    internal_array.stub to_json: :the_json_representation
    expect( subject.to_json ).to eq( :the_json_representation )
  end

  it "loads in property values from a JSON object representation using #load_json" do
    init_options[:internal_array] = [:anything]

    json = <<-EOS
      [
        "abc",
        123,
        null,
        false
      ]
    EOS

    subject.load_json json

    expect( subject.to_a ).to eq( [
      'abc',
      123,
      nil,
      false
    ] )
  end

end
