require 'spec_helper'

describe SonJay::ObjectModel do

  describe "a subclass that defines (value and modeled-object) properties" do

    let( :model_class     ) { subject_module::RootModel }
    let( :model_instance  ) { model_class.new }
    let( :detail_xy_class ) { subject_module::DetailXY }

    let( :subject_module ) {
      mod = Module.new
      mod::M = mod

      module mod::M

        class RootModel < SonJay::ObjectModel
          class << self
            def properties_block_called_count
              @properties_block_called_count ||= 0
            end
            attr_writer :properties_block_called_count
          end

          properties do
            RootModel.properties_block_called_count += 1
            property :aaa
            property :bbb
            property :detail_xy , model: DetailXY
            property :detail_z  , model: DetailZ
          end
        end

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

    it "does not immediately invoke its properties block when declared" do
      expect( model_class.properties_block_called_count ).
        to eq( 0 )
    end

    describe '::array_class' do
      it "returns a model-array subclass for entries of this type" do
        array_class = model_class.array_class
        expect( array_class.ancestors ).to include( SonJay::ModelArray )
        expect( array_class.entry_class ).to eq( model_class )
      end
    end

    describe "#sonj_content" do
      let( :sonj_content ) { model_instance.sonj_content }

      it "has number of entries equal to number of defined properties" do
        expect( sonj_content.length ).to eq( 4 )
      end

      it "has name-indexed settable/gettable value properties by string or symbol" do
        sonj_content[ :aaa  ] =  1
        sonj_content[ 'bbb' ] = 'XYZ'

        expect( sonj_content[ 'aaa' ] ).to eq(  1    )
        expect( sonj_content[ :bbb  ] ).to eq( 'XYZ' )
      end

      it "has nil defaults for value properties" do
        expect( sonj_content[ 'aaa' ] ).to be_nil
        expect( sonj_content[ :bbb  ] ).to be_nil
      end

      it "has name-indexed gettable values for defined modeled-object properties by string or symbol" do
        expect( sonj_content['detail_xy'] ).
          to be_kind_of( subject_module::DetailXY )
        expect( sonj_content[:detail_z] ).
          to be_kind_of( subject_module::DetailZ )
      end

      it "rejects access to an undefined property" do
        expect{ sonj_content['qq'] }.to raise_exception(
          described_class::Properties::NameError
        )
      end

    end

    it "has direct property accessor methods for each property" do
      model_instance.aaa, model_instance.bbb = 11, 22
      expect( [model_instance.aaa, model_instance.bbb] ).to eq( [11, 22] )
      expect( model_instance.detail_xy ).
        to be_kind_of( subject_module::DetailXY )
      expect( model_instance.detail_z ).
        to be_kind_of( subject_module::DetailZ )
    end

    it "serializes to a JSON object representation w/ value properties" do
      instance = detail_xy_class.new
      instance.xxx, instance.yyy = 'ABC', nil

      actual_json = instance.to_json

      actual_data = JSON.parse( actual_json)
      expected_data = {'xxx' => 'ABC', 'yyy' => nil}
      expect( actual_data ).to eq( expected_data )
    end

    it "serializes to a JSON object representation w/ value and object properties" do
      model_instance.aaa = 1
      model_instance.bbb = 2
      model_instance.detail_xy.xxx = 11
      model_instance.detail_xy.yyy = 12
      model_instance.detail_z.zzz  = 21

      actual_json = model_instance.to_json

      actual_data = JSON.parse( actual_json)
      expected_data = {
        'aaa' => 1 ,
        'bbb' => 2 ,
        'detail_xy' => { 'xxx' => 11, 'yyy' => 12 } ,
        'detail_z'  => { 'zzz' => 21 } ,
      }
      expect( actual_data ).to eq( expected_data )
    end

    it "parses from JSON to an instance with properties filled in" do
      json = <<-JSON
        {
          "aaa":  123  ,
          "bbb": "XYZ" ,
          "detail_xy": { "xxx": "x", "yyy": "y" } ,
          "detail_z":  { "zzz": "z" }
        }
      JSON

      instance = model_class.parse_json( json )

      expect( instance.aaa ).to eq( 123 )
      expect( instance.bbb ).to eq('XYZ')
      expect( instance.detail_xy.xxx ).to eq('x')
      expect( instance.detail_xy.yyy ).to eq('y')
      expect( instance.detail_z.zzz  ).to eq('z')
    end

    context "with more properties added via an additional ::properies block" do
      before do

        model_class.class_eval do
          properties do
            property :mmm
            property :nnn
          end
        end

      end

      it "has number of entries equal to total number of defined properties" do
        expect( model_instance.sonj_content.length ).to eq( 6 )
      end
      
    end

  end

  describe "a subclass with a directly self-referential property specification" do
    let!( :subclass ) {
      cc = lambda{ component }
      Class.new(described_class) do
        properties do ; property :component, model: cc.call ; end
      end
    }

    let!( :component ) {
      cc = lambda{ sub_component }
      Class.new(described_class) do
        properties do ; property :component, model: cc.call ; end
      end
    }

    let!( :sub_component ) {
      cc = lambda{ subclass }
      Class.new(described_class) do
        properties do ; property :component, model: cc.call ; end
      end
    }

    it "raises an infinte regress error when property_definitions are resolved" do
      expect{ subclass.property_definitions }.
        to raise_exception( SonJay::InfiniteRegressError )
    end
  end

  describe "a subclass with an indirectly self-referential property specification" do
    let!( :subclass ) {
      Class.new(described_class) do
        this_model_class = self
        properties do
          property :a
          property :b, model: this_model_class
        end
      end
    }

    it "raises an infinte regress error when property_definitions are resolved" do
      expect{ subclass.property_definitions }.
        to raise_exception( SonJay::InfiniteRegressError )
    end
  end

end
