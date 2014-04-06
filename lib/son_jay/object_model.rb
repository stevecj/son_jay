require 'son_jay/object_model/properties'
require 'son_jay/object_model/property_definition'

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

    class << self

      def json_create(json)
        data = JSON.parse( json )
        instance = new
        instance.sonj_properties.load_data data
        instance
      end

      def properties(&property_initializations)
        @property_initializations = property_initializations
      end

      def property_definitions
        @property_definitions ||= begin
          definitions = []

          definer = PropertiesDefiner.new(definitions)
          definer.instance_eval &@property_initializations
          definitions.each do |d|
            name = d.name
            class_eval <<-CODE
              def #{name}         ; sonj_properties[#{name.inspect}]         ; end
              def #{name}=(value) ; sonj_properties[#{name.inspect}] = value ; end
            CODE
          end
          definitions
        end
      end

    end

    attr_reader :sonj_properties

    def initialize
      definitions = self.class.property_definitions
      @sonj_properties = ObjectModel::Properties.new( definitions )
    end

    def to_json(*args)
      sonj_properties.to_json(*args)
    end

  end
end
