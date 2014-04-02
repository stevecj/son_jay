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

    it "has direct property accessor methods for each property" do
      instance = subclass.new
      instance.abc, instance.xyz = 11, 22

      expect( [instance.abc, instance.xyz] ).to eq( [11, 22] )
    end

    it "serializes to a JSON object representation w/ property values" do
      instance = subclass.new
      instance.abc, instance.xyz = 'ABC', nil

      actual_json = instance.to_json

      actual_data = JSON.parse( actual_json)
      expected_data = {'abc' => 'ABC', 'xyz' => nil}
      expect( actual_data ).to eq( expected_data )
    end
  end

end
