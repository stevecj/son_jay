require 'spec_helper'

describe SonJay::ObjectModel::PropertyDefinition do

  it "has a nil model class for a nil instruction" do
    instance = described_class.new( :a, nil )
    expect( instance.model_class ).to be_nil
  end

  it "has a model class for a model class instruction" do
    model_class = Class.new

    instance = described_class.new( :a, model_class )
    expect( instance.model_class ).to eq( model_class )
  end

  it "has a value-array class for an empty-array instruction" do
    instance = described_class.new( :a, [] )
    expect( instance.model_class ).to eq( SonJay::ValueArray )
  end

  it "has a model-array class for an array w/ model class entry" do
    entry_model_class = Class.new do
      class Array ; end
      def self.array_class ; Array ; end
    end

    instance = described_class.new( :a, [ entry_model_class ] )
    expect( instance.model_class ).to eq( entry_model_class::Array )
  end
end
