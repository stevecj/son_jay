require 'forwardable'

module SonJay
  class ObjectModel
    class Properties

      class NameError < KeyError
        def initialize(name)
          super "No such property name as %s" % name.inspect
        end
      end

      extend Forwardable

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

      def_delegator :@data, :has_key?, :has_name?

      def [](name)
        name = "#{name}"
        @data.fetch(name)
      rescue KeyError
        raise NameError.new(name)
      end

      def []=(name, value)
        name = "#{name}"
        raise NameError.new(name) unless @data.has_key?(name)
        @data[name] = value
      end

      def load_data(data)
        data.each_pair do |name, value|
          load_property name, value
        end
      end

      def load_property(name, value)
        name = "#{name}"
        return unless @data.has_key?( name )
        if @model_properties.include?( name )
          @data[name].sonj_content.load_data value
        else
          @data[name] = value
        end
      end

      def has_name?(name)
        @data.has_key?( "#{name}" )
      end

      def to_json(options = ::JSON::State.new)
        options = ::JSON::State.new(options) unless options.kind_of?(::JSON::State)
        @data.to_json( options )
      end

    end
  end
end
