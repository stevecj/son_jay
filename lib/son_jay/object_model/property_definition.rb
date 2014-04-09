module SonJay
  class ObjectModel

    class PropertyDefinition
      attr_reader :name, :model_factory

      def initialize(name, instruction = nil)
        @name          = name
        @model_factory = model_factory_for_instruction(instruction)
      end

      private

      def model_factory_for_instruction(instruction)
        if instruction.nil?
          nil
        elsif instruction == []
          SonJay::ValueArray.method( :new )
        elsif instruction.respond_to?(:to_ary)
          array_model_class(instruction).method( :new )
        elsif instruction.respond_to?( :new )
          instruction.method( :new )
        end
      end

      private

      def array_model_class(instruction)
        return instruction unless instruction.respond_to?(:to_ary)

        sub_instruction = instruction.first
        sub_model_class = array_model_class( sub_instruction )
        sub_model_class.array_class
      end

    end

  end
end
