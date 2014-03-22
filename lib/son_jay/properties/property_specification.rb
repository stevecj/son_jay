module SonJay
  module Properties
    class PropertySpecification
      attr_reader :name

      def initialize(name, options={})
        @name = "#{name}"
        @options = options
        @property_factory = property_factory_for_options
      end

      def build_property
        @property_factory.call(name, options)
      end

      private

      attr_reader :options

      def property_factory_for_options
        if options.has_key?(:object_model)
          Properties::ModeledObject.method(:new)
        else
          Properties::Value.method(:new)
        end
      end
    end
  end
end
