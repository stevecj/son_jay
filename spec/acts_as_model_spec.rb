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

        def sonj_content
          @sonj_content ||= Content.new
        end
      end
    }

    describe '::json_create' do
      it "returns a new instance with parsed JSON data loaded into its #sonj_content object" do
        instance = klass.json_create( '{"hello": "world"}' )
        loaded_data = instance.sonj_content.loaded_data
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
