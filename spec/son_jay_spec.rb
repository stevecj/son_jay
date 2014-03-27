require 'spec_helper'

describe SonJay do
  it "has a version number" do
    SonJay::VERSION.should_not be_nil
  end
end

describe 'SonJay()' do
  it "delegates to SonJay::ModelFactory.new" do
    factory = SonJay{ [] }
    model = factory.call
    expect( model ).to be_kind_of( SonJay::ValueArrayModel )
  end
end
