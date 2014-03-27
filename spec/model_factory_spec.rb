require 'spec_helper'

describe SonJay::ModelFactory do
  subject{ described_class.new{ instruction } }

  context "given a class as an instruction" do
    let(:instruction){ Object }
    it "creates instances of the given class" do
      expect( subject.call ).to be_kind_of( Object )
    end
  end

  context "given an empty array as an instruction" do
    let(:instruction){ [] }
    it "creates value array model instances" do
      expect( subject.call ).to be_kind_of( SonJay::ValueArrayModel )
    end
  end

  context "given an array with a class element" do
    let(:instruction){ [Object] }
    it "creates model array instances for elements of the given class" do
      model = subject.call
      expect( model.push! ).to be_kind_of( Object )
    end
  end
end
