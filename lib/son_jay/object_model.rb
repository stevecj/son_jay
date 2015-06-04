require 'set'
require 'son_jay/object_model/content_data'
require 'son_jay/object_model/content'
require 'son_jay/object_model/property_definition'
require 'son_jay/object_model/property_definitions'
require 'son_jay/object_model/properties_definer'

module SonJay
  class ObjectModel
    include ActsAsModel

    attr_reader :model_content

    def initialize
      definitions = self.class.property_definitions
      @model_content = ObjectModel::Content.new(
        definitions, self.class.extras_allowed?
      )
    end

    def to_json(*args)
      model_content.to_json( *args )
    end

    def to_h
      model_content.to_h
    end

    def []=(name, value)
      name = self.class.property_definitions.name_from(name)
      target = property_store_for( name )
      target[ name ] = value
    end

    def [](name)
      name = self.class.property_definitions.name_from(name)
      source = property_store_for( name )
      source[ name ]
    end

    def fetch(name)
      model_content.fetch( name )
    end

    private

    def property_store_for(name_string)
      store = model_content
      if (
        self.class.extras_allowed? &&
        (! self.class.property_definitions.include_name?(name_string) )
      ) then
        store = model_content.extra
      end
      store
    end

    class << self

      def extras_allowed?
        @extras_allowed ||= false
      end

      def property_definitions
        @property_definitions ||= _evaluate_property_definitions
      end

      private

      def properties(&property_initializations)
        _property_initializations << property_initializations
      end

      def allow_extras(allowed = true)
        @extras_allowed = allowed
      end

      def _evaluate_property_definitions
        _populate_property_definitions
        _validate_model_dependencies!
        _apply_property_definitions property_definitions
        _property_definitions
      end

      def _populate_property_definitions
        @property_definitions =
          _inherited_property_definitions +
          PropertyDefinitions.from_initializations(
            _property_initializations
          )
      end

      def _inherited_property_definitions
        self == SonJay::ObjectModel ?
          PropertyDefinitions.new :
          superclass.property_definitions
      end

      def _property_definitions
        @property_definitions
      end

      def _property_initializations
        @property_initializations ||= []
      end

      def _apply_property_definitions(definitions)
        definitions.each do |d|
          name = d.name
          property_defs_module.module_eval <<-CODE
            def #{name}         ; model_content[#{name.inspect}]         ; end
            def #{name}=(value) ; model_content[#{name.inspect}] = value ; end
          CODE
        end
      end

      def property_defs_module
        @property_defs_module ||= begin
          Module.new.tap do |mod|
            const_set :HasPropertyAccessors, mod
            include mod
          end
        end
      end


      def _validate_model_dependencies!(dependants=Set.new)
        raise InfiniteRegressError if dependants.include?(self)
        dependants << self
        property_definitions.hard_model_dependencies.each do |d|
          next unless d.respond_to?( :_validate_model_dependencies!, true )
          d.send :_validate_model_dependencies!, dependants
        end
      end
    end

  end
end
