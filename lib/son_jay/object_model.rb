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

    # Returns a JSON representation of the model instance.
    def to_json(*args)
      as_json.to_json(*args)
    end

    # Returns a hash, that will be turned into a JSON representation of this model instance.
    def as_json(*)
      # Assuming (without actually knowing) that it is faster to
      # duplicate a hash and replace existing values than to build
      # a new hash.
      data = _sonj_properties.dup
      data.each_pair do |k,v|
        data[k] = v.as_json
      end
      data
    end

    private

    def _sonj_properties
      @_sonj_properties ||= {}
    end
  end
end
