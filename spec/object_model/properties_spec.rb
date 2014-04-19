require 'spec_helper'

describe SonJay::ObjectModel::Properties do
  subject{
    described_class.new( [
      SonJay::ObjectModel::PropertyDefinition.new( 'aaa' ) ,
      SonJay::ObjectModel::PropertyDefinition.new( 'bbb' ) ,
      SonJay::ObjectModel::PropertyDefinition.new( 'ccc' ) ,
      SonJay::ObjectModel::PropertyDefinition.new( 'ddd', ddd_model_class ) ,
    ] )
  }

  let( :ddd_model_class ) { Class.new do
    class Content
      def initialize(model) ; @model = model ; end
      def load_data(data) ; @model.class.loaded_data = data ; end
    end
    class << self ; attr_accessor :loaded_data ; end
    def to_json(*) ; '"ddd..."' ; end
    def sonj_content ; Content.new(self) ; end
  end }

  it "has an entry for each property name specified during initialization" do
    expect( subject.length ).to eq( 4 )
    expect( subject ).to have_name('aaa')
    expect( subject ).to have_name('bbb')
    expect( subject ).to have_name('ccc')
    expect( subject ).to have_name('ddd')
  end

  describe "property value access by name" do
    it "reads nil by default for an existing value property" do
      expect( subject['aaa'] ).to be_nil
    end

    it "writes and reads existing value properties" do
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

    it "reads an instance of the model for a modeled attribute" do
      expect( subject[:ddd] ).to be_kind_of( ddd_model_class )
    end
  end

  describe "#to_json" do
    it "returns a JSON object representation with attribute values" do
      subject['aaa'] = 'abc'
      subject['ccc'] = true

      actual_json = subject.to_json

      actual_data = JSON.parse( actual_json )
      expected_data = {
        'aaa' => 'abc' ,
        'bbb' =>  nil ,
        'ccc' =>  true ,
        'ddd' => "ddd..." ,
      }
      expect( actual_data ).to eq( expected_data )
    end
  end

  describe "#load_property" do
    it "writes to existing value properties" do
      subject.load_property( 'bbb', 11 )
      subject.load_property( 'ccc', 12 )

      expect( subject['bbb'] ).to eq( 11 )
      expect( subject['ccc'] ).to eq( 12 )
    end

    it "loads data into existing modeled properties" do
      subject.load_property( 'ddd', 'some data' )
      expect( ddd_model_class.loaded_data ).to eq( 'some data' )
    end

    it "ignores attempts to write to non-existent properties" do
      expect{ subject.load_property('xx', 10) }.
        not_to change{ subject.length }
    end

    it "allows string or symbol for property name" do
      subject.load_property( 'aaa' , 888 )
      subject.load_property( :ccc  , 999 )

      expect( subject['aaa'] ).to eq( 888 )
      expect( subject['ccc'] ).to eq( 999 )
    end
  end

  describe "#load_data" do
    it "populates property values from hash entries" do
      subject.load_data({
        'bbb' => 'abc' ,
        'ccc' =>  false ,
        'ddd' => 'something...' ,
      })
      expect( subject['aaa'] ).to be_nil
      expect( subject['bbb'] ).to eq( 'abc' )
      expect( subject['ccc'] ).to eq( false )
      expect( ddd_model_class.loaded_data ).to eq( 'something...' )
    end
  end

  describe '#assimilate' do
    it "populates value properties from source object's available attributes" do
      source_obj = double( :source_obj, {
        respond_to?: false ,
        aaa:         123 ,
        ccc:         456 ,
      } )
      source_obj.stub( :respond_to? ).with( 'aaa' ).and_return true
      source_obj.stub( :respond_to? ).with( 'ccc' ).and_return true

      subject.assimilate source_obj

      expect( subject[:aaa] ).to eq( 123 )
      expect( subject[:bbb] ).to be_nil
      expect( subject[:ccc] ).to eq( 456 )
    end
  end

  describe '#disseminate_to' do
    it "populates available target attributes from value properties" do
      subject[ :bbb ] = 123
      subject[ :ccc ] = 456

      target_obj = double( :target_obj, respond_to?: false )
      target_obj.stub( :respond_to? ).with( 'bbb=' ).and_return true
      target_obj.stub( :respond_to? ).with( 'ccc=' ).and_return true

      expect( target_obj ).to receive( :bbb= ).with 123
      expect( target_obj ).to receive( :ccc= ).with 456

      subject.disseminate_to target_obj
    end
  end

end
