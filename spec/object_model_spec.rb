require 'spec_helper'

describe SonJay::ObjectModel do
  context "a subclass" do
    let( :subclass ){ Class.new(described_class) }

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

      it "adds a property value setter method to each instance" do
        instance = subclass.new
        instance.some_property = :some_value
        actual_property_value = instance.sonj_property(:some_property).value
        expect( actual_property_value ).to eq( :some_value )
      end
    end

    describe '#to_json' do
      let( :subclass ){ Class.new(described_class) do
        property :a
        property :bb
        property :ccc
        property :dddd
      end }

      let( :instance ){ subclass.new }

      it "serializes to JSON as a representation of an object with property values" do
        instance.a    = 'Text'
        instance.bb   = 11340
        instance.ccc  = false
        instance.dddd = nil

        expected_json_equiv = <<-EOS
          {
            "a":"Text",
            "bb":11340,
            "ccc":false,
            "dddd":null
          }
        EOS

        actual_json = instance.to_json

        expect( JSON.parse(actual_json) ).to eq( JSON.parse(expected_json_equiv) )
      end
    end
  end
end
