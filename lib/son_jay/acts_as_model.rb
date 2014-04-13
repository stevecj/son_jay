module SonJay
  module ActsAsModel

    def self.included(other)
      other.extend ClassBehavior
    end

    module ClassBehavior

      def array_class
        @array_class ||= begin
          klass = SonJay::ModelArray(self)
          const_set :Array, klass
        end
      end

    end

  end
end
