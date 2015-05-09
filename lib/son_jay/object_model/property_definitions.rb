require 'set'

module SonJay
  class ObjectModel

    class PropertyDefinitions
      extend Forwardable
      include Enumerable

      def self.from_initializations(property_initializations)
        new.tap do |instance|
          definer = PropertiesDefiner.new( instance )
          property_initializations.each do |pi|
            definer.instance_eval &pi
          end
        end
      end

      def initialize
        @definitions = []
        @names = Set.new
        @name_symbol_to_string_map = {}
      end

      def +(other)
        sum = self.class.new
        each do |property_definition|
          sum << property_definition
        end
        other.each do |property_definition|
          sum << property_definition
        end
        sum
      end

      def <<(definition)
        @definitions << definition
        name = definition.name
        @names << name
        @name_symbol_to_string_map[name.to_sym] = name
      end

      def_delegators :@definitions, :each

      def name_from(name)
        case name
        when String then name
        when Symbol then @name_symbol_to_string_map.fetch(name, name)
        else            "#{name}"
        end
      end

      def include_name?(name)
        name = name_from( name )
        names.include?( name )
      end

      def hard_model_dependencies
        map( &:model_class ).compact.uniq
      end

      def names
        @names.freeze
      end
    end

  end
end
