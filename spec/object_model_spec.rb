require 'spec_helper'

describe SonJay::ObjectModel do

  describe "a subclass that defines value properties" do

    describe '::array_class' do
      it "returns a model-array subclass for entries of this type" do
        array_class = subclass.array_class
        puts array_class.ancestors
        expect( array_class.ancestors ).to include( SonJay::ModelArray )
        expect( array_class.entry_class ).to eq( subclass )
      end
    end

    let( :subclass ) {
      Class.new(described_class) do
        properties do
          property :abc
          property :xyz
        end
      end
    }

    describe "#sonj_content" do
      it "has name-indexed settable/gettable values for defined properties" do
        instance = subclass.new

        content = instance.sonj_content
        expect( content.length ).to eq( 2 )

        content[:abc] = 1
        content[:xyz] = 'XYZ'

        expect( content[:abc] ).to eq( 1 )
        expect( content[:xyz] ).to eq( 'XYZ' )
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

  describe "a subclass that defines value and modeled-object properties" do
    let( :subclass ) {
      dmc_1, dmc_2 = detail_model_class_1, detail_model_class_2
      pbcs = property_block_calls
      Class.new(described_class) do
        properties do
          pbcs << 1
          property :a
          property :obj_1, model: dmc_1
          property :obj_2, model: dmc_2
        end
      end
    }

    let( :property_block_calls ) { [] }

    let( :detail_model_class_1 ) {
      Class.new(described_class) do
        properties do
          property :aaa
          property :bbb
        end
      end
    }

    let( :detail_model_class_2 ) {
      Class.new(described_class) do
        properties do
          property :ccc
        end
      end
    }

    it "does not immediately invoke its properties block when declared" do
      _ = subclass
      expect( property_block_calls ).to be_empty
    end

    describe "#sonj_content" do
      it "has an entry for each defined property" do
        content = subclass.new.sonj_content
        expect( content.length ).to eq( 3 )
      end
    end

    describe "#sonj_content" do
      it "has name-indexed settable/gettable values for defined value properties" do
        content = subclass.new.sonj_content
        content[:a] = 1
        expect( content[:a] ).to eq( 1 )
      end

      it "has name-indexed gettable values for defined modeled-object properties" do
        content = subclass.new.sonj_content
        expect( content[:obj_1] ).to be_kind_of( detail_model_class_1 )
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
      expect{ subclass.property_definitions }.to raise_exception( SonJay::InfiniteRegressError )
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
      expect{ subclass.property_definitions }.to raise_exception( SonJay::InfiniteRegressError )
    end
  end

end
