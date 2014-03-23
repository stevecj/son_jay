module SonJay
  class ObjectModel

    class << self
      include Enumerable

      def json_create(json)
        instance = new
        instance.load_json(json)
        instance
      end

      def property(name, options={})
        new_spec = Properties::PropertySpecification.new(name, options)
        properties[new_spec.name] = new_spec
        class_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{name}=(value)
            sonj_property(#{name.inspect}).value = value
          end
          def #{name}
            sonj_property(#{name.inspect}).value
          end
        EOS
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
      data.each_pair do |k,p|
        data[k] = p.as_json
      end
      data
    end

    def load_json(json)
      data = JSON.parse(json)
      load_data data
    end

    def load_data(data)
      _sonj_properties.each do |k,p|
        p.load_data data.fetch(k)
      end
    end

    private

    def _sonj_properties
      @_sonj_properties ||= {}
    end
  end
end
