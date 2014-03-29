module SonJay
  class ObjectModel
    class PropertiesDefiner
      def initialize(names)
        @names = names
      end

      def property(name)
        @names << name.to_s
      end
    end

    class ValueProperty
      attr_reader :name
      attr_accessor :value
      def initialize(name) ; @name = name ; end
    end

    class << self
      def properties(&property_initializations)
        @property_initializations = property_initializations
      end

      def property_names
        @property_names ||= begin
          names = []
          definer = PropertiesDefiner.new(names)
          definer.instance_eval &@property_initializations
          names
        end
      end
    end

    attr_reader :sonj_properties

    def initialize
      prop_names = self.class.property_names
      @sonj_properties = Hash[
        prop_names.map{ |name| [name, ValueProperty.new(name)] }
      ]
    end

  end
end
