module SonJay
  class ModelFactory

    def initialize(&instruction_getter)
      @instruction_getter = instruction_getter
    end

    def call
      if instruction.respond_to?(:to_ary)
        if instruction.empty?
          ValueArrayModel.new
        else
          element_factory = ModelFactory.new{ instruction.first }
          ModelArray.new{ element_factory }
        end
      elsif instruction.kind_of?( Class )
        instruction.new
      end
    end

    alias new call

    private

    attr_reader :instruction_getter

    def instruction
      @instruction ||= instruction_getter.call
    end

  end
end
