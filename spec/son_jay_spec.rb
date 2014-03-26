require 'spec_helper'

describe SonJay do
  it "has a version number" do
    SonJay::VERSION.should_not be_nil
  end

  describe '::[]' do
    it "returns a value-array model factory/classoid" do
      factory = subject[]
      expect( factory.call ).to be_kind_of( SonJay::ValueArrayModel )
      expect( factory.new ).to be_kind_of( SonJay::ValueArrayModel )
    end
  end
end
