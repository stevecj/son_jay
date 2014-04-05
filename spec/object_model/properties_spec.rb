require 'spec_helper'

describe SonJay::ObjectModel::Properties do
  subject{
    described_class.new( ['aaa', 'bbb', 'ccc'] )
  }

  it "has an entry for each property name specified during initialization" do
    expect( subject.length ).to eq( 3 )
    expect( subject ).to have_name('aaa')
    expect( subject ).to have_name('bbb')
    expect( subject ).to have_name('ccc')
  end

  describe "property value access by name" do
    it "reads nil by default for an existing property" do
      expect( subject['aaa'] ).to be_nil
    end

    it "writes and reads existing properties" do
      subject['bbb'] = 10
      subject['aaa'] = 11

      expect( subject['bbb'] ).to eq( 10 )
      expect( subject['aaa'] ).to eq( 11 )
    end

    it "refuses to read a non-existent property" do
      expect{ subject['abc'] }.to raise_exception( described_class::NameError )
    end

    it "refuses to write a non-existent property" do
      expect{ subject['abc'] = 1 }.to raise_exception( described_class::NameError )
    end

    it "allows reading/writing by symbol or string for property name" do
      subject['aaa'] = 10
      subject[:bbb]  = 11

      expect( subject[:aaa]  ).to eq( 10 )
      expect( subject['bbb'] ).to eq( 11 )
    end
  end

  describe "#to_json" do
    it "returns a JSON object representation with attribute values" do
      subject['aaa'] = 'abc'
      subject['ccc'] = true

      actual_json = subject.to_json

      actual_data = JSON.parse( actual_json )
      expected_data = {'aaa' => 'abc', 'bbb' => nil, 'ccc' => true}
      expect( actual_data ).to eq( expected_data )
    end
  end

  describe "load_property" do
    it "writes to existing properties" do
      subject.load_property( 'bbb', 11 )
      subject.load_property( 'ccc', 12 )

      expect( subject['bbb'] ).to eq( 11 )
      expect( subject['ccc'] ).to eq( 12 )
    end

    it "ignores attempts to write to non-existent properties" do
      expect{ subject.load_property('xx', 10) }.
        not_to change{ subject.length }
      expect( subject.values.select{|v| ! v.nil? } ).to be_empty
    end

    it "allows string or symbol for property name" do
      subject.load_property( 'aaa' , 888 )
      subject.load_property( :ccc  , 999 )

      expect( subject['aaa'] ).to eq( 888 )
      expect( subject['ccc'] ).to eq( 999 )
    end
  end

  describe "load_data" do
    it "populates property values from hash entries" do
      subject.load_data({
        'bbb' => 'abc' ,
        'ccc' => false ,
      })
      expect( subject['aaa'] ).to be_nil
      expect( subject['bbb'] ).to eq( 'abc' )
      expect( subject['ccc'] ).to eq( false )
    end
  end

end
