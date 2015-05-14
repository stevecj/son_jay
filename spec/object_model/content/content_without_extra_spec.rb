require 'spec_helper'

module SonJay

  describe ObjectModel::Content::ContentWithoutExtra do
    let( :detail_xy_class ) { models_module::DetailXY }
    let( :detail_z_class  ) { models_module::DetailZ  }

    let( :models_module ) {
      mod = Module.new
      mod::M = mod

      module mod::M
        class DetailXY < SonJay::ObjectModel
          properties do
            property :xxx
            property :yyy
          end
        end

        class DetailZ < SonJay::ObjectModel
          properties do
            property :zzz
          end
        end
      end

      mod
    }

    let( :value_property_initializations ) {
      ->(*) {
        property :aaa
        property :bbb
      }
    }
    let( :object_model_property_initializations ) {
      _xy_class = detail_xy_class
      _z_class  = detail_z_class
      ->(*) {
        property :detail_xy , model: _xy_class
        property :detail_z  , model: [_z_class]
      }
    }

    context "with various properties defined" do
      subject {
        described_class.new( property_defs )
      }
      let( :property_defs ) {
        ObjectModel::PropertyDefinitions.from_initializations( [
          value_property_initializations,
          object_model_property_initializations
        ] )
      }

      it "rejects assignment of an undefined property" do
        expect{
          subject['qq'] = 0
        }.to raise_exception(
          SonJay::PropertyNameError
        )
      end

      it "implements enumerable behaviors" do
        expect( subject ).to respond_to( :entries )
      end

      it "enumerates entries for all defined properties" do
        subject['bbb'] = 'B'
        subject['detail_xy'].xxx = 'X'
        actual_pairs = []
        subject.each do |*pair|
          actual_pairs << pair
        end
        expect( actual_pairs ).to match_array( [
          [ 'aaa', nil ],
          [ 'bbb', 'B' ],
          [ 'detail_xy', subject['detail_xy'] ],
          [ 'detail_z',  subject['detail_z' ] ],
        ] )
      end
    end

    context "with value properties defined" do
      subject {
        described_class.new( property_defs )
      }
      let( :property_defs ) {
        ObjectModel::PropertyDefinitions.from_initializations( [
          value_property_initializations
        ] )
      }

      it "has an initial number of entries equal to its number of defined properties" do
        expect( subject.length ).to eq( 2 )
      end

      it "has name-indexed settable/gettable value properties by string or symbol" do
        subject[ :aaa  ] =  1
        subject[ 'bbb' ] = 'XYZ'

        expect( subject[ 'aaa' ] ).to eq(  1    )
        expect( subject[ :bbb  ] ).to eq( 'XYZ' )
      end

      it "has all property values nil by default" do
        expect( subject[ 'aaa' ] ).to be_nil
        expect( subject[ :bbb  ] ).to be_nil
      end
    end

    context "with model properties defined" do
      subject {
        described_class.new( property_defs )
      }
      let( :property_defs ) {
        ObjectModel::PropertyDefinitions.from_initializations( [
          object_model_property_initializations
        ] )
      }

      it "has name-indexed gettable values for defined properties by string or symbol" do
        expect( subject[ 'detail_xy' ] ).to be_kind_of( detail_xy_class )
        expect( subject[ :detail_z   ] ).to be_kind_of( detail_z_class::Array )
      end
    end
  end

end
