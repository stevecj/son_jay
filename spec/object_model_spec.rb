require 'spec_helper'

describe SonJay::ObjectModel do
  context "a subclass" do
    let(:subclass){ Class.new(described_class) }

    describe "::property" do
      before do
        subclass.class_eval do
          property :some_property
        end
      end

      it "adds a named property specification to the subclass" do

        actual_property = subclass[:some_property]
        expect( actual_property ).to be_kind_of( SonJay::Property::Specification )
        expect( actual_property.name ).to eq( 'some_property' )
      end

      it "adds a named sonj_property to each instance" do
        instance = subclass.new
        actual_property = instance.sonj_property(:some_property)
        expect( actual_property ).to be_kind_of( SonJay::Property )
        expect( actual_property.name ).to eq( 'some_property' )
      end
    end
  end
end
