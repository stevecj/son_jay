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
      it "has name-indexed settable/gettable values for defined properties" do
        instance = subclass.new

        properties = instance.sonj_properties
        expect( properties.length ).to eq( 2 )

        properties[:abc] = 1
        properties[:xyz] = 'XYZ'

        expect( properties[:abc] ).to eq( 1 )
        expect( properties[:xyz] ).to eq( 'XYZ' )
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

    describe '::json_create' do
      it "creates an instance with properties filled in from parsed JSON" do
        json = <<-JSON
          {
            "abc":  123  ,
            "xyz": "XYZ"
          }
        JSON

        instance = subclass.json_create( json )

        expect( instance.abc ).to eq(  123  )
        expect( instance.xyz ).to eq( 'XYZ' )
      end
    end

  end

end
