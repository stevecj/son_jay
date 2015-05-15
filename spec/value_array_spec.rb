require 'spec_helper'

describe SonJay::ValueArray do
  it "is array-like" do
    expect( subject.to_ary ).to eq( subject )
    expect( subject << 1 << 2 ).to eq( [1, 2] )
  end

  describe '#model_content' do
    it "returns the instance itself" do
      expect( subject.model_content ).to eq( subject )
    end
  end

  describe '#load_data' do
    it "replaces content with given array" do
      subject << 1
      expect( subject.length ).to eq( 1 )

      subject.load_data( [7, 8, 9] )

      expect( subject.entries ).to eq( [7, 8, 9] )
    end
  end

  describe '#to_json' do
    it "returns a JSON representation of the array w/ values" do
      subject.replace( [1, 2, 'three'] )

      actual_json = subject.to_json

      parsed_json = JSON.parse( actual_json )
      expect( parsed_json ).to eq( [1, 2, 'three'] )
    end
  end

end
