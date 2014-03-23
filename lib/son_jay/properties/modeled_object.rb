module SonJay
  module Properties
    class ModeledObject < Properties::Property
      extend Forwardable

      def value
        @value ||= model_class.new
      end

      def model_class
        @model_class ||= @model_class_getter.call
      end

      def_delegators :value, *[
        :load_data ,
      ]

      private

      def process_init_options(options)
        @model_class_getter = options[:object_model]
        # TODO: Raise error if :object_model option missing or not `.call`able
      end
    end
  end
end
