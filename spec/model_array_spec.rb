require 'spec_helper'

describe SonJay::ModelArray do
  describe '::new' do
    it "returns an empty instance" do
      instance = described_class.new(:anything)
      expect( instance.empty? ).to eq( true )
      expect{ instance.fetch(0) }.to raise_exception( IndexError )
    end
  end

  describe "#push!" do
    it "appends a new factory-created element and returns the element" do
      element_factory_getter = double( :element_factory_getter )
      element_factory = double( :element_factory )
      elements = [ :first, :second ]
      allow( element_factory_getter ).to receive( :call ).and_return( element_factory )
      allow( element_factory ).to receive( :call ){ elements.shift }

      instance = described_class.new( element_factory_getter )

      instance.push!
      instance.push!

      expect( instance.first ).to eq( :first  )
      expect( instance.last  ).to eq( :second )
    end
  end

  describe "#unshift!" do
    it "prepends a new factory-created element and returns the element" do
      e_factory = double( :e_factory )
      elements = [ :first, :second, :third ]
      allow( e_factory ).to receive( :call ){ elements.shift }

      instance = described_class.new( ->{ e_factory } )
      2.times{ instance.push! }
      expect( instance.length ).to eq( 2 ) # Sanity check

      instance.unshift!

      expect( instance.first ).to eq( :third )
    end
  end
end
