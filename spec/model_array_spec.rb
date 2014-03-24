require 'spec_helper'

describe SonJay::ModelArray do
  describe '::new' do
    it "returns an empty instance for 0 initial length" do
      instance = described_class.new(:anything, 0)
      expect( instance.empty? ).to eq( true )
      expect{ instance.fetch(0) }.to raise_exception( IndexError )
    end

    it "returns an instance of the given length having factory-created elements" do
      e_factory = double( :e_factory )
      elements = [ :first, :second, :third ]
      allow( e_factory ).to receive( :call ){ elements.shift }

      instance = described_class.new( e_factory, 3 )
      expect( instance ).to eq( [:first, :second, :third] )
    end
  end

  describe "#push!" do
    it "appends a new factory-created element and returns the element" do
      e_factory = double( :e_factory )
      elements = [ :first, :second, :third ]
      allow( e_factory ).to receive( :call ){ elements.shift }

      instance = described_class.new( e_factory, 2 )
      expect( instance.length ).to eq( 2 ) # Sanity check

      instance.push!

      expect( instance.last ).to eq( :third )
    end
  end

  describe "#unshift!" do
    it "prepends a new factory-created element and returns the element" do
      e_factory = double( :e_factory )
      elements = [ :first, :second, :third ]
      allow( e_factory ).to receive( :call ){ elements.shift }

      instance = described_class.new( e_factory, 2 )
      expect( instance.length ).to eq( 2 ) # Sanity check

      instance.unshift!

      expect( instance.first ).to eq( :third )
    end
  end
end
