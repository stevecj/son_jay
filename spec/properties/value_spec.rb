require 'spec_helper'

describe SonJay::Properties::Value do
  subject{ described_class.new(:the_property_name) }

  it "has a settable/gettable value" do
    subject.value = :the_value
    expect( subject.value ).to eq( :the_value )
  end

  it "assigns data to its value using #load_data" do
    subject.load_data :the_data
    expect( subject.value ).to eq( :the_data )
  end

end
