require 'spec_helper'

describe SonJay::Properties::ModeledObject do
  subject{ described_class.new(
    :the_property_name,
    object_model: model_class_getter
  ) }

  let( :model_class_getter ) { double(:model_class_getter) }

  describe '#model_class' do
    it "delegates to the #call method of its :object_model initialization option" do
      expect( model_class_getter ).
        to receive( :call ).and_return( :the_model_class )

      expect( subject.model_class ).to eq( :the_model_class )
    end
  end

  describe '#value' do
    it "returns an a modeled object instance" do
      expect( model_class_getter ).
        to receive( :call ).and_return( Class.new )

      expect( subject.value ).to be_kind_of( subject.model_class )
    end
  end

end
