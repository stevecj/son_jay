module SonJay
  class ObjectModel
    module Properties

      class PropertiesWithoutExtra < Abstract

        def extra
          raise SonJay::DisabledMethodError
        end

        private

        def load_extra_property(name_string, value)
          # Ignore extra.
        end

        def hash_for_json
          @data
        end

      end

    end
  end
end
