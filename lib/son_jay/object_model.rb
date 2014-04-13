require 'set'
require 'son_jay/object_model/properties'
require 'son_jay/object_model/property_definition'

module SonJay
  class ObjectModel
    include ActsAsModel

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
        instance.sonj_content.load_data data
        instance
      end

      def properties(&property_initializations)
        @property_initializations = property_initializations
      end

      def property_definitions
        @property_definitions ||= nil
        return @property_definitions if @property_definitions

        definitions = []

        definer = PropertiesDefiner.new(definitions)
        definer.instance_eval &@property_initializations
        @property_definitions = definitions

        validate_model_dependencies!

        definitions.each do |d|
          name = d.name
          class_eval <<-CODE
            def #{name}         ; sonj_content[#{name.inspect}]         ; end
            def #{name}=(value) ; sonj_content[#{name.inspect}] = value ; end
          CODE
        end

        @property_definitions
      end

      private

      def validate_model_dependencies!(dependants=Set.new)
        raise InfiniteRegressError if dependants.include?(self)
        dependants << self
        hard_model_dependencies.each do |d|
          next unless d.respond_to?(:validate_model_dependencies!, true)
          d.send :validate_model_dependencies!, dependants
        end
      end

      def hard_model_dependencies
        property_definitions.map(&:model_class).compact.uniq
      end
    end

    attr_reader :sonj_content

    def initialize
      definitions = self.class.property_definitions
      @sonj_content = ObjectModel::Properties.new( definitions )
    end

    def to_json(*args)
      sonj_content.to_json(*args)
    end

  end
end
