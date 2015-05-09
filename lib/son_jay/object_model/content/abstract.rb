require 'forwardable'

module SonJay
  class ObjectModel
    module Content

      class Abstract
        extend Forwardable
        include Enumerable

        attr_reader :model_properties

        def initialize(property_definitions)
          @property_definitions = property_definitions
          @data = {}
          @model_properties = Set.new

          init_properties \
            *property_definitions.partition { |md| !! md.model_class }
        end

        def_delegators :@data, *[
          :length ,
          :values ,
        ]

        def [](name)
          name = property_definitions.name_from(name)
          @data[name]
        end

        def fetch(name)
          name = property_definitions.name_from(name)
          @data.fetch(name)
        rescue KeyError
          raise PropertyNameError.new(name)
        end

        def []=(name, value)
          name = property_definitions.name_from(name)
          raise PropertyNameError.new(name) unless @data.has_key?(name)
          @data[name] = value
        end

        def load_data(data)
          data.each_pair do |name, value|
            load_property name, value
          end
        end

        def load_property(name, value)
          name = property_definitions.name_from(name)
          if @data.has_key?( name )
            load_defined_property name, value
          else
            load_extra_property name, value
          end
        end

        def extra
          raise NotImplementedError, "Subclass responsibility"
        end

        def to_json(options = ::JSON::State.new)
          options = ::JSON::State.new(options) unless options.kind_of?(::JSON::State)
          hash_for_json.to_json( options )
        end

        def each
          raise NotImplementedError, "Subclass responsibility"
        end

        private

        def init_properties(model_property_defs, value_property_defs)
          value_property_defs.each do |d|
            @data[d.name] = nil
          end

          model_property_defs.each do |d|
            @data[d.name] = d.model_class.new
            @model_properties << d.name
          end
        end

        def load_defined_property(name_string, value)
          if @model_properties.include?( name_string )
            @data[ name_string ].sonj_content.load_data value
          else
            @data[ name_string ] = value
          end
        end

        def load_extra_property(name_string, value)
          raise NotImplementedError, "Subclass responsibility"
        end

        def hash_for_json
          raise NotImplementedError, "Subclass responsibility"
        end

        attr_reader :property_definitions

      end

    end
  end
end
