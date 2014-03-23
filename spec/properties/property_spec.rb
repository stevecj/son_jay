require 'spec_helper'

describe SonJay::Properties::Property do
  subject{ described_class.new(:the_property_name) }

  it "has a zero-argument value reader method" do
    expect( subject.method(:value).arity ).to eq( 0 )
  end

  it "has a 1-argument value writer method" do
    expect( subject.method(:value=).arity ).to eq( 1 )
  end

  it "has a 1-argument #load_data method" do
    expect( subject.method(:load_data).arity ).to eq( 1 )
  end
end
