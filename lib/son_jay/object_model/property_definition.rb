module SonJay
  class ObjectModel

    class PropertyDefinition
      attr_reader :name, :model_class

      def initialize(name, model_class = nil)
        @name        = name
        @model_class = model_class
      end

    end

  end
end
