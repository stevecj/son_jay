module SonJay
  module ActsAsModel

    def self.included(other)
      other.extend ClassBehavior
    end

    # Deprecated
    def sonj_content
      model_content
    end

    module ClassBehavior

      def parse_json(json)
        data = JSON.parse( json )
        instance = new
        instance.model_content.load_data data
        instance
      end

      def array_class
        @array_class ||= begin
          klass = SonJay::ModelArray( self )
          const_set :Array, klass
        end
      end

    end

  end
end
