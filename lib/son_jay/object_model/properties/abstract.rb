require 'forwardable'

module SonJay
  class ObjectModel
    module Properties

      class Abstract
        extend Forwardable

        attr_reader :model_properties

        def initialize(property_definitions)
          @data = {}
          @model_properties = Set.new
          property_definitions.each do |d|
            is_model_property = !! d.model_class
            @data[d.name] = is_model_property ? d.model_class.new : nil
            @model_properties << d.name if is_model_property
          end
        end

        def_delegators :@data, *[
          :length ,
          :values ,
        ]

        def [](name)
          name = "#{name}" unless String === name
          @data[name]
        end

        def fetch(name)
          name = "#{name}" unless String === name
          @data.fetch(name)
        rescue KeyError
          raise PropertyNameError.new(name)
        end

        def []=(name, value)
          name = "#{name}" unless String === name
          raise PropertyNameError.new(name) unless @data.has_key?(name)
          @data[name] = value
        end

        def load_data(data)
          data.each_pair do |name, value|
            load_property name, value
          end
        end

        def load_property(name, value)
          name = "#{name}" unless String === name
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

        private

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

      end

    end
  end
end
