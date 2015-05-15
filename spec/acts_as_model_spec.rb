require 'spec_helper'

describe SonJay::ActsAsModel do
  context "included as a class mixin" do

    let( :klass ) {
      Class.new do
        include SonJay::ActsAsModel

        class Content
          attr_reader :loaded_data

          def load_data(data)
            @loaded_data = data
          end
        end

        def model_content
          @model_content ||= Content.new
        end
      end
    }

    describe '::parse_json' do
      it "returns a new instance with parsed JSON data loaded into its #model_content object" do
        instance = klass.parse_json( '{"hello": "world"}' )
        loaded_data = instance.model_content.loaded_data
        expect( loaded_data ).to eq( {'hello' => 'world'} )
      end
    end

    describe '::array_class' do
      it "returns an array model class with the target as its entry class" do
        result = klass.array_class
        expect( result.entry_class ).to eq( klass )
      end
    end

  end
end
