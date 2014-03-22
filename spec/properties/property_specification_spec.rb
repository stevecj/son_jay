require 'spec_helper'

describe SonJay::Properties::PropertySpecification do

  describe '#build_property' do

    context "for an instance with no initialization options" do
      let(:subject){
        described_class.new(:property_name)
      }

      it "builds a named value property instance" do
        property = subject.build_property

        expect( property ).to be_kind_of( SonJay::Properties::Value )
        expect( property.name ).to eq( 'property_name' )
      end
    end

    context "for an instance initialized with an :object_model option" do
      let(:subject){
        described_class.new(:property_name, object_model: ->{ :the_object_model_class } )
      }

      it "builds a named object property instance for the given object model class" do
        property = subject.build_property

        expect( property ).to be_kind_of( SonJay::Properties::ModeledObject )
        expect( property.name ).to eq( 'property_name' )
        expect( property.model_class ).to eq( :the_object_model_class )
      end
    end

  end

end
