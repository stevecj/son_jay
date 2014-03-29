require 'spec_helper'

describe SonJay::ObjectModel do

  describe "a subclass that defines value properties" do
    let( :subclass ) {
      Class.new(described_class) do
        properties do
          property :abc
          property :xyz
        end
      end
    }

    describe "#sonj_properties" do
      it "has named properties with settable/gettable value attributes" do
        instance = subclass.new

        properties = instance.sonj_properties
        expect( properties.length ).to eq( 2 )

        ['abc', 'xyz'].each do |prop_name|
          property = properties[prop_name]
          expect( property.name ).to eq( prop_name )
          property.value = :something
          expect( property.value ).to eq( :something )
        end
      end
    end

  end

end
