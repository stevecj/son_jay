module SonJay
  class ObjectModel

    class PropertyDefinitions
      extend Forwardable
      include Enumerable

      def initialize
        @definitions = []
        @name_symbol_to_string_map = {}
      end

      def <<(definition)
        @definitions << definition
        name = definition.name
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
    end

  end
end
