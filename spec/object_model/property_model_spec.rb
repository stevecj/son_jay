require 'spec_helper'

describe SonJay::ObjectModel::PropertyDefinition do

  it "has a nil model factory for a nil instruction" do
    instance = described_class.new( :a, nil )
    expect( instance.model_factory ).to be_nil
  end

  it "has a model factory for a model class instruction" do
    model_class = Class.new
    instance = described_class.new( :a, model_class )
    factory = instance.model_factory
    expect( factory.call ).to be_kind_of( model_class )
  end

  it "has a value-array factory for an empty-array instruction" do
    instance = described_class.new( :a, [] )
    factory = instance.model_factory
    expect( factory.call ).to be_kind_of( SonJay::ValueArray )
  end
end
