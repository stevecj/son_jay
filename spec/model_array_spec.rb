require 'spec_helper'

describe 'SonJay::ModelArray()' do
  it "returns a subclass of ModelArray for entries of given type" do
    entry_class_1 = Class.new
    entry_class_2 = Class.new

    array_model_subclass_1 = SonJay::ModelArray( entry_class_1 )
    array_model_subclass_2 = SonJay::ModelArray( entry_class_2 )

    expect( array_model_subclass_1.entry_class ).to eq( entry_class_1 )
    expect( array_model_subclass_2.entry_class ).to eq( entry_class_2 )
  end
end

describe SonJay::ModelArray do
  describe "a subclass for entries of a modeled type" do
    let( :subclass ) { Class.new(described_class).tap{ |c|
      c.send :entry_class=, entry_class
    } }
    let( :entry_class ) { Class.new do
      class Content
        def initialize( entry ) ; @entry = entry ; end
        def load_data(data) ; @entry.loaded_data = data ; end
      end

      attr_accessor :loaded_data
      def sonj_content ; Content.new(self) ; end
    end }

    describe '::array_class' do
      it "returns a model-array subclass for entries of this model-array type (nested array)" do
        array_class = subclass.array_class
        puts array_class.ancestors
        expect( array_class.ancestors ).to include( SonJay::ModelArray )
        expect( array_class.entry_class ).to eq( subclass )
      end
    end

    it "produces instances that are initially empty" do
      instance = subclass.new
      expect( instance ).to be_empty
      expect( instance.length ).to eq( 0 )
    end

    describe "#additional" do
      it "adds a new entry of the modeled type, and returns the entry" do
        instance = subclass.new

        entry_0 = instance.additional
        entry_1 = instance.additional

        expect( entry_0 ).to be_kind_of( entry_class )
        expect( instance.entries ).to eq( [entry_0, entry_1] )
      end
    end

    describe '#load_data' do
      it "loads entries in the given enumerable into its own model instance entries" do
        instance = subclass.new

        instance.load_data( ['entry 0 data', 'entry 1 data'] )

        expect( instance.length ).to eq( 2 )
        expect( instance[0].loaded_data ).to eq( 'entry 0 data' )
        expect( instance[1].loaded_data ).to eq( 'entry 1 data' )
      end
    end
  end
end
