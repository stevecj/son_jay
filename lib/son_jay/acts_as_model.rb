module SonJay
  module ActsAsModel

    def self.included(other)
      other.extend ClassBehavior
    end

    module ClassBehavior

      def parse_json(json)
        data = JSON.parse( json )
        instance = new
        instance.sonj_content.load_data data
        instance
      end

      def array_class
        @array_class ||= begin
          klass = SonJay::ModelArray(self)
          const_set :Array, klass
        end
      end

    end

  end
end
