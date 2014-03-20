module SonJay
  class Property
    attr_reader :name

    def initialize(name)
      @name = name
    end

    class Specification
      attr_reader :name

      def initialize(name)
        @name = "#{name}"
      end

      def build_property
        Property.new(name)
      end
    end
  end
end
