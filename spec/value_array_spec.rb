require 'spec_helper'

describe SonJay::ValueArray do

  describe '#sonj_content' do
    it "returns the instance itself" do
      expect( subject.sonj_content ).to eq( subject )
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
end
