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
        def initialize(entry) ; @entry = entry ; end
        def load_data(data) ; @entry.loaded_data = data ; end
      end

      attr_accessor :loaded_data
      def model_content ; Content.new(self) ; end
    end }

    describe '::array_class' do
      it "returns a model-array subclass for entries of this model-array type (nested array)" do
        array_class = subclass.array_class
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

    describe '#model_content' do
      it "returns the model array" do
        expect( subject.model_content ).to equal( subject )
      end
    end

    describe '#freeze' do
      it "causes the instance to behave as frozen" do
        instance = subclass.new
        instance.freeze
        expect{ instance.additional }.to raise_exception( RuntimeError )
      end
    end

    describe '#dup' do
      it "makes a shallow copy" do
        instance = subclass.new
        instance.additional
        actual_dup = instance.dup
        expect( actual_dup[0] ).to eq( instance[0] )
        actual_dup.additional
        expect( instance.length ).to eq( 1 )
      end

      it "returns a thawed copy of a frozen instance" do
        instance = subclass.new
        instance.freeze
        actual_dup = instance.dup
        expect( actual_dup ).not_to be_frozen
        expect{ actual_dup.additional }.not_to raise_exception
      end
    end

    describe '#clone' do
      it "makes a shallow copy" do
        instance = subclass.new
        instance.additional
        actual_clone = instance.clone
        expect( actual_clone[0] ).to eq( instance[0] )
        actual_clone.additional
        expect( instance.length ).to eq( 1 )
      end

      it "returns a frozen copy of a frozen instance" do
        instance = subclass.new
        instance.freeze
        actual_clone = instance.clone
        expect( actual_clone ).to be_frozen
        expect{ actual_clone.additional }.to raise_exception( RuntimeError )
      end
    end
  end
end
