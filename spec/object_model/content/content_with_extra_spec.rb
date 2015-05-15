require 'spec_helper'

module SonJay

  describe ObjectModel::Content::ContentWithExtra do
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

      it "provides access to an extra-properties object" do
        expect( subject.extra.to_h ).to eq( {} )
      end

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

      it "enumerates entries for all defined properties and extra assigned property values" do
        subject['bbb'] = 'B'
        subject['detail_xy'].xxx = 'X'
        subject.extra['qqq'] = 'Q'
        subject.extra['rrr'] = nil
        actual_pairs = []
        subject.each do |*pair|
          actual_pairs << pair
        end
        expect( actual_pairs ).to match_array( [
          [ 'aaa', nil ],
          [ 'bbb', 'B' ],
          [ 'qqq', 'Q' ],
          [ 'rrr', nil ],
          [ 'detail_xy', subject['detail_xy'] ],
          [ 'detail_z',  subject['detail_z' ] ],
        ] )
      end

      describe '#freeze' do
        it "causes the instance to behave as frozen" do
          subject.freeze
          expect{ subject['aaa'] = 1 }.to raise_exception( RuntimeError )
          expect{ subject.extra['qq']  = 2 }.to raise_exception( RuntimeError )
        end
      end

      describe '#dup' do
        it "makes a shallow copy" do
          subject[ 'aaa' ] = 'A'
          subject[ 'bbb' ] = 'B'
          subject.extra['qq'] = 'Q'
          actual_dup = subject.dup
          expect( actual_dup[ 'aaa' ] ).to eq( 'A' )
          expect( actual_dup[ 'bbb' ] ).to eq( 'B' )
          expect( actual_dup[ 'detail_xy' ] ).to equal( subject[ 'detail_xy' ] )
          expect( actual_dup[ 'detail_z'  ] ).to equal( subject[ 'detail_z'  ] )
          actual_dup[ 'bbb' ]    = 'BB'
          actual_dup.extra['qq'] = 'QQ'
          expect( subject['bbb']      ).to eq( 'B' )
          expect( subject.extra['qq'] ).to eq( 'Q' )
        end

        it "returns a thawed copy of a frozen instance" do
          subject.extra['qq'] = 11
          subject.freeze
          actual_dup = subject.dup
          expect( actual_dup ).not_to be_frozen
          actual_dup['aaa']      = 98
          actual_dup.extra['qq'] = 99
          expect( actual_dup['aaa']      ).to eq( 98 )
          expect( actual_dup.extra['qq'] ).to eq( 99 )
        end
      end

      describe '#clone' do
        it "makes a shallow copy" do
          subject[ 'aaa' ] = 'A'
          subject[ 'bbb' ] = 'B'
          subject.extra['qq'] = 'Q'
          actual_clone = subject.clone
          expect( actual_clone[ 'aaa' ] ).to eq( 'A' )
          expect( actual_clone[ 'bbb' ] ).to eq( 'B' )
          expect( actual_clone[ 'detail_xy' ] ).to equal( subject[ 'detail_xy' ] )
          expect( actual_clone[ 'detail_z'  ] ).to equal( subject[ 'detail_z'  ] )
          expect( actual_clone.extra['qq'] ).to eq('Q')
          actual_clone['bbb']      = 'BB'
          actual_clone.extra['qq'] = 'QQ'
          expect( subject['bbb']      ).to eq( 'B' )
          expect( subject.extra['qq'] ).to eq( 'Q' )
        end

        it "returns a frozen copy of a frozen instance" do
          subject.extra['qq'] = 1
          subject.freeze
          actual_clone = subject.clone
          expect( actual_clone ).to be_frozen
          expect{ subject['aaa'] = 9 }.to raise_exception( RuntimeError )
          expect{ subject.extra['qq'] = 9 }.to raise_exception( RuntimeError )
        end
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
