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

    class << self
      def properties(&property_initializations)
        @property_initializations = property_initializations
      end

      def property_names
        @property_names ||= begin
          names = []
          definer = PropertiesDefiner.new(names)
          definer.instance_eval &@property_initializations
          names.each do |name|
            class_eval <<-CODE
              def #{name}         ; sonj_properties[#{name.inspect}]         ; end
              def #{name}=(value) ; sonj_properties[#{name.inspect}] = value ; end
            CODE
          end
          names
        end
      end
    end

    attr_reader :sonj_properties

    def initialize
      prop_names = self.class.property_names
      @sonj_properties = Hash[
        prop_names.map{ |name| [name, nil] }
      ]
    end

    def to_json
      as_json.to_json
    end

    def as_json
      sonj_properties
    end

  end
end
