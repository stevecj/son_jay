module SonJay
  class ObjectModel
    class PropertiesDefiner

      def initialize(property_definitions)
        @property_definitions = property_definitions
      end

      def property(name, options={})
        name = "#{name}"
        @property_definitions << PropertyDefinition.new( name, options[:model] )
      end

    end
  end
end
