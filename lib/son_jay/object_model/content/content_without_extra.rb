module SonJay
  class ObjectModel
    module Content

      class ContentWithoutExtra < Abstract

        def extra
          raise SonJay::DisabledMethodError
        end

        def each
          @data.each do |(name, value)|
            yield name, value
          end
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
