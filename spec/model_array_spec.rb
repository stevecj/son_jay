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

    describe "an instance" do
      subject { subclass.new }

      it "is initially empty" do
        expect( subject ).to be_empty
        expect( subject.length ).to eq( 0 )
      end

      describe "#additional" do
        it "adds a new entry of the modeled type, and returns the entry" do
          entry_0 = subject.additional
          entry_1 = subject.additional

          expect( entry_0 ).to be_kind_of( entry_class )

          expect( subject.entries ).to eq( [
            entry_0,
            entry_1
          ] )
        end
      end

      describe '#load_data' do
        it "loads entries in the given enumerable into its own model instance entries" do
          subject.load_data( ['entry 0 data', 'entry 1 data'] )

          expect( subject.length ).to eq( 2 )
          expect( subject[0].loaded_data ).to eq( 'entry 0 data' )
          expect( subject[1].loaded_data ).to eq( 'entry 1 data' )
        end
      end

      describe '#model_content' do
        it "returns the model array" do
          expect( subject.model_content ).to equal( subject )
        end
      end

      describe '#freeze' do
        it "causes the instance to behave as frozen" do
          subject.freeze
          expect{ subject.additional }.to raise_exception( RuntimeError )
        end
      end

      describe '#dup' do
        it "makes a shallow copy" do
          subject.additional
          actual_dup = subject.dup
          expect( actual_dup[0] ).to eq( subject[0] )
          actual_dup.additional
          expect( subject.length ).to eq( 1 )
        end

        it "returns a thawed copy of a frozen instance" do
          subject.freeze
          actual_dup = subject.dup
          expect( actual_dup ).not_to be_frozen
          expect{ actual_dup.additional }.not_to raise_exception
        end
      end

      describe '#clone' do
        it "makes a shallow copy" do
          subject.additional
          actual_clone = subject.clone
          expect( actual_clone[0] ).to eq( subject[0] )
          actual_clone.additional
          expect( subject.length ).to eq( 1 )
        end

        it "returns a frozen copy of a frozen instance" do
          subject.freeze
          actual_clone = subject.clone
          expect( actual_clone ).to be_frozen
          expect{ actual_clone.additional }.to raise_exception( RuntimeError )
        end
      end

    end
  end
end
