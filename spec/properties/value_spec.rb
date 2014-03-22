require 'spec_helper'

describe SonJay::Properties::Value do
  subject{ described_class.new(:the_property_name) }

  it "has a settable/gettable value" do
    subject.value = :the_value
    expect( subject.value ).to eq( :the_value )
  end

end
