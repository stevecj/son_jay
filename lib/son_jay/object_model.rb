module SonJay
  class ObjectModel

    class << self
      include Enumerable

      def property(name)
        new_spec = Property::Specification.new(name)
        properties[new_spec.name] = new_spec
        new_spec.define_model_value_accessor self
      end

      def [](property_name)
        property_name = "#{property_name}"
        properties[property_name]
      end

      def each
        properties.values.each do |spec|
          yield spec
        end
      end

      private

      def properties
        @properties ||= {}
      end
    end

    def initialize
      self.class.each do |spec|
        _sonj_properties[spec.name] = spec.build_property
      end
    end

    def sonj_property(name)
      name = "#{name}"
      _sonj_properties[name]
    end

    private

    def _sonj_properties
      @_sonj_properties ||= {}
    end
  end
end
