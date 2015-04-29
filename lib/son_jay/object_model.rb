require 'set'
require 'son_jay/object_model/properties'
require 'son_jay/object_model/property_definition'
require 'son_jay/object_model/properties_definer'
require 'son_jay/object_model/extra_data'

module SonJay
  class ObjectModel
    include ActsAsModel

    attr_reader :sonj_content

    def initialize
      definitions = self.class.property_definitions
      @sonj_content = ObjectModel::Properties.new(
        definitions, self.class.extras_allowed?
      )
    end

    def to_json(*args)
      sonj_content.to_json( *args )
    end

    def []=(name, value)
      name = "#{name}" unless String === name
      target = property_store_for( name )
      target[ name ] = value
    end

    def [](name)
      name = "#{name}" unless String === name
      source = property_store_for( name )
      source[ name ]
    end

    def fetch(name)
      sonj_content.fetch( name )
    end

    private

    def property_store_for(name_string)
      store = sonj_content
      if (
        self.class.extras_allowed? &&
        (! sonj_content.model_properties.include?(name_string) )
      ) then
        store = sonj_content.extra
      end
      store
    end

    class << self

      def allow_extras(allowed = true)
        @extras_allowed = allowed
      end

      def extras_allowed?
        @extras_allowed ||= false
      end

      def properties(&property_initializations)
        @property_initializations =
          Array(@property_initializations) << property_initializations
      end

      def property_definitions
        @property_definitions ||= nil
        return @property_definitions if @property_definitions

        definitions = []

        definer = PropertiesDefiner.new( definitions )
        (@property_initializations || []).each do |pi|
          definer.instance_eval &pi
        end
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
          next unless d.respond_to?( :validate_model_dependencies!, true )
          d.send :validate_model_dependencies!, dependants
        end
      end

      def hard_model_dependencies
        property_definitions.map( &:model_class ).compact.uniq
      end
    end

  end
end
