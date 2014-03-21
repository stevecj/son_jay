module SonJay
  class Property
    attr_reader :name
    attr_accessor :value

    def initialize(name)
      @name = name
    end

    def as_json(*)
      value
    end

    class Specification
      attr_reader :name

      def initialize(name)
        @name = "#{name}"
      end

      def build_property
        Property.new(name)
      end

      def define_model_value_accessor(model_class)
        model_class.class_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{name}=(value)
            sonj_property(#{name.inspect}).value = value
          end
          def #{name}
            sonj_property(#{name.inspect}).value
          end
        EOS
      end
    end
  end
end
