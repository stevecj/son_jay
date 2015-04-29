require 'forwardable'

module SonJay
  class ObjectModel
    class Properties
      extend Forwardable

      attr_reader :model_properties

      def initialize(property_definitions, extra_allowed)
        @data = {}
        @model_properties = Set.new
        property_definitions.each do |d|
          is_model_property = !! d.model_class
          @data[d.name] = is_model_property ? d.model_class.new : nil
          @model_properties << d.name if is_model_property
        end
        @extra_allowed = extra_allowed
      end

      def extra_allowed?
        @extra_allowed
      end

      def_delegators :@data, *[
        :length ,
        :values ,
      ]

      def [](name)
        name = "#{name}"
        @data[name]
      end

      def fetch(name)
        name = "#{name}"
        @data.fetch(name)
      rescue KeyError
        raise PropertyNameError.new(name)
      end

      def []=(name, value)
        name = "#{name}"
        raise PropertyNameError.new(name) unless @data.has_key?(name)
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

      def extra
        raise SonJay::DisabledMethodError unless extra_allowed?
        #TODO: Enforce use of string keys.
        @extra ||= {}
      end

      def to_json(options = ::JSON::State.new)
        options = ::JSON::State.new(options) unless options.kind_of?(::JSON::State)
        all_data = @data
        all_data = all_data.merge( extra ) if extra_allowed? && (! extra.empty? )
        all_data.to_json( options )
      end

    end
  end
end
