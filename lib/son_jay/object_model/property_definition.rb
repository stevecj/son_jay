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
        elsif instruction.respond_to?( :new )
          instruction.method( :new )
        end
      end
    end

  end
end
