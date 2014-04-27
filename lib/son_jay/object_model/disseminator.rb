module SonJay
  class ObjectModel

    class Disseminator
      VALID_OPTION_KEYS = [:map]

      def initialize(data, target_obj, options)
        validate_options options
        @data       = data
        @target_obj = target_obj
        @mappings   = options[:map] || {}
      end

      def call
        @data.each do |prop_name, value|
          setter_name = target_setter_for(prop_name)
          next unless target_obj.respond_to?( setter_name )
          target_obj.public_send setter_name, value
        end
      end

      private

      attr_reader :target_obj, :map

      def mapping(prop_name)
        @mappings[prop_name.to_sym] || {}
      end

      def target_setter_for(prop_name)
        target_attr = mapping(prop_name)[:to_attr] || prop_name
        "#{target_attr}="
      end

      def validate_options(options)
        invalid_keys = options.keys - VALID_OPTION_KEYS
        unless invalid_keys.empty?
          msg = "Invalid option key(s) #{invalid_keys.map(&:inspect) * ' '} given. " +
                "Valid keys are #{VALID_OPTION_KEYS.map(&:inspect) * ' '}."
          raise ArgumentError, msg
        end
      end
    end

  end
end
