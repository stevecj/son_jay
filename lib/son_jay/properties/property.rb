module SonJay
  module Properties
    class Property
      attr_reader :name

      def initialize(name, options={})
        @name = name
        process_init_options options
      end

      # Returns the value of the property.
      def value
        raise NotImplementedError, "Subclass responsibility"
      end

      # Sets the value of the proerty if applicable. The method always
      # exists so that it can be cleanly delegated to, but invoking it
      # will raise a NotImplementedError exception if it is not applicable.
      def value=(v)
        raise NotImplementedError,
          "Value assignment is not applicable to this kind of property"
      end

      def as_json(*)
        value
      end

      
      private

      def process_init_options(options)
        # TODO: Implement default-case option checking?
      end
    end
  end
end
